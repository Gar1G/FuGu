using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FoodApp.Models
{
    public class User
    {
       
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]  //Allows us to generate our own userid
        public int UserId { get; set; }
        public string Email { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string Password { get; set; }


    }
}