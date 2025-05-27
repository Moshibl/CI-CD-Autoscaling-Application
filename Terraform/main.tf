# --------------------------------------------------
# Creating VPC Componenets
# --------------------------------------------------

module "VPC" {
  source        = "./Modules/VPC"
  VPC_Name      = var.VPC_Name
  VPC_CIDR      = var.VPC_CIDR
  PubSub1_CIDR  = var.PubSub1_CIDR
  PubSub2_CIDR  = var.PubSub2_CIDR
  PrivSub1_CIDR = var.PrivSub1_CIDR
  PrivSub2_CIDR = var.PrivSub2_CIDR
  PrivSub3_CIDR = var.PrivSub3_CIDR
  PrivSub4_CIDR = var.PrivSub4_CIDR
  PubSub1_AZ    = var.AZ1
  PubSub2_AZ    = var.AZ2
  PrivSub1_AZ   = var.AZ1
  PrivSub2_AZ   = var.AZ2
  PrivSub3_AZ   = var.AZ1
  PrivSub4_AZ   = var.AZ2
}

# --------------------------------------------------
# Creating SecurityGroups
# --------------------------------------------------

module "SecurityGroups" {
  source = "./Modules/SecurityGroup"
  VPC_ID = module.VPC.VPC_ID
}

# --------------------------------------------------
# Creating KeyPair
# --------------------------------------------------

module "KeyPair" {
  source   = "./Modules/KeyPair"
  Key_Name = var.Key_Name
}

# --------------------------------------------------
# Creating Managed EC2
# --------------------------------------------------


module "Master" {
  source        = "./Modules/EC2"
  AMI           = var.AMI
  Instance_Name = var.Master_Name
  Instance_Type = var.Instance_Type
  Subnet_Id     = module.VPC.PubSub1_ID
  SG            = module.SecurityGroups.Master_SG
  Is_Public     = true
  Key_Name      = var.Key_Name
}

module "Slave" {
  source        = "./Modules/EC2"
  AMI           = var.AMI
  Instance_Name = var.Slave_Name
  Instance_Type = var.Instance_Type
  Subnet_Id     = module.VPC.PrivSub1_ID
  SG            = module.SecurityGroups.Slave_SG
  Is_Public     = false
  Key_Name      = var.Key_Name
}


# --------------------------------------------------
# Creating AutoScaling Groups
# --------------------------------------------------

module "ProxyAutoScaling" {
  source             = "./Modules/ASG"
  LaunchTMP_Name     = var.Proxy_TMP
  AMI                = var.NGINX_AMI
  Instance_Type      = var.Instance_Type
  Key_Name           = var.Key_Name
  Security_Group_Ids = [module.SecurityGroups.Proxy_SG]
  UserData = base64encode(templatefile("./Modules/ASG/UserData/Proxy.tmpl", {
    ALB_DNS = module.Internal_ALB.ALB_DNS
  }))

  ASG_Name          = var.ProxyASG
  ASG_Instance_Name = var.ProxyASG_Instance
  ASG_Instance_Role = var.Proxy_Instance_Role
  Desired_Capacity  = 2
  Min_Size          = 1
  Max_Size          = 2
  VPC_Zone_Id       = [module.VPC.PrivSub1_ID, module.VPC.PrivSub2_ID]
  TG_Arns           = [module.External_ALB.TG_Arn]
  depends_on        = [module.VPC, module.Internal_ALB]
}


module "PrivateAutoScaling" {
  source             = "./Modules/ASG"
  LaunchTMP_Name     = var.Priv_TMP
  AMI                = var.NGINX_AMI
  Instance_Type      = var.Instance_Type
  Key_Name           = var.Key_Name
  Security_Group_Ids = [module.SecurityGroups.Backend_SG]
  # UserData           = base64encode(file("./Modules/ASG/UserData/Backend.sh"))

  ASG_Name          = var.PrivASG
  ASG_Instance_Name = var.PrivASG_Instance
  ASG_Instance_Role = var.Backend_Instance_Role
  Desired_Capacity  = 2
  Min_Size          = 1
  Max_Size          = 2
  VPC_Zone_Id       = [module.VPC.PrivSub3_ID, module.VPC.PrivSub4_ID]
  TG_Arns           = [module.Internal_ALB.TG_Arn]
  depends_on        = [module.VPC]
}

# --------------------------------------------------
# Creating LoadBalancers
# --------------------------------------------------

module "External_ALB" {
  source            = "./Modules/ALB"
  LB_Name           = var.EXT_Name
  Is_Internal       = false
  Security_Group_Id = [module.SecurityGroups.External_ALB_SG]
  Subnet_Ids        = [module.VPC.PubSub1_ID, module.VPC.PubSub2_ID]
  TargetGroupName   = var.ProxyTG
  VPC_ID            = module.VPC.VPC_ID
}

module "Internal_ALB" {
  source            = "./Modules/ALB"
  LB_Name           = var.INT_Name
  Is_Internal       = true
  Security_Group_Id = [module.SecurityGroups.Internal_ALB_SG]
  Subnet_Ids        = [module.VPC.PrivSub1_ID, module.VPC.PrivSub2_ID]
  TargetGroupName   = var.PrivTG
  VPC_ID            = module.VPC.VPC_ID
}

# --------------------------------------------------
# END
# --------------------------------------------------

resource "null_resource" "Master_Startup" {
  depends_on = [module.ProxyAutoScaling, module.PrivateAutoScaling]
  # triggers = {
  #   master_ip = module.Master.EC2_PUB_IP
  # }
  provisioner "local-exec" {
    command = <<EOT
      bash ${var.WorkDir}/Scripts/SSH-Config.sh "${module.KeyPair.Key_Path}"
      ANSIBLE_CONFIG=${var.WorkDir}/Ansible/ansible.cfg \
      ansible-playbook -i ${var.WorkDir}/Ansible/inventory ${var.WorkDir}/Ansible/master-playbook.yml
    EOT
  }
}

resource "null_resource" "JumpServerScript" {
  depends_on = [null_resource.Master_Startup]
  provisioner "local-exec" {
    command = <<EOT
      bash ../Scripts/InventoryGen.sh
      ansible-playbook -i ../Ansible/inventory ../Ansible/slave-playbook.yml
    EOT
  }
}

resource "null_resource" "PrintAdminPassword" {
  depends_on = [null_resource.JumpServerScript]

  connection {
    type        = "ssh"
    host        = module.Master.EC2_PUB_IP
    user        = "ubuntu"
    private_key = file("~/.ssh/Key")
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Printing Admin Password...'",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    ]
  }
}

