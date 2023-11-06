variable "users" {

  type = list(object({
    name : string
    email : string
    groups : list(string)
    }
  ))
  default = [
    {
      name : "anmolvw",
      email : "anmolvw07@gmail.com",
      groups = ["developer"]
    },
    {
      name : "amulyavw",
      email : "anmulya@gmail.com"
      groups = ["developer"]
    }
  ]
}

variable "vpc_id" {
  default = "vpc-0adc54db253f9c7c4"
}

