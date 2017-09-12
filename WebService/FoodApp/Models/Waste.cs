using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace FoodApp.Models
{
    public class Waste
    {

        //Class represents entire database of waste usage across all users
        //Primary key includes userid and timestamp
        [Key, Column(Order =1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int UserId { get; set; }
        [Key, Column(Order =0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public DateTime Timestamp { get; set; }
        public int Weight { get; set; }

        public Waste()
        {

        }

        public Waste (int uID, DateTime timestamp, int w)
        {
            UserId = uID;
            Timestamp = timestamp;
            Weight = w;
        }
    }

    
}