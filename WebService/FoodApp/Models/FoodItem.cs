using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

using System.Linq;
using System.Web;

namespace FoodApp.Models
{
    public class FoodItem
    {
        //Both product id and userid used to form a key. In reality productid is sufficient enough
        [Key,Column(Order = 0)]
        public int ProductId { get; set; }
        [Key, Column(Order = 1)]
        public int UserId { get; set; } //hash value of userid string
        public string ProductName { get; set; }
        public int Weight { get; set; } //Takes values in grams
        public double Price { get; set; }
        public DateTime Purchased { get; set; } 
        public DateTime Expiry { get; set; }
        public int Priority { get; set; } //takes values 1,2,3 (1: Main Ingredient, 2: Accompaniment, 3: Garnish)
        public int AmountRemaining { get; set; }
        public bool inFridge { get; set; }

        public FoodItem()
        {

        }

        public FoodItem(int id, int userid, string name, int w, double p, DateTime purchase, DateTime expire, int prior, int rem, bool infridge)
        {
            ProductId = id;
            UserId = userid;
            ProductName = name;
            Weight = w;
            Price = p;
            Purchased = purchase;
            Expiry = expire;
            Priority = prior;
            AmountRemaining = rem;
            inFridge = infridge;
        }

    }


    public class UserFoodList
    {
        public int UserId;
        public List<FoodItem> FoodItems = new List<FoodItem>();

        public UserFoodList() { }
        public UserFoodList(int Id)
        {
            UserId = Id;
        }
    }
}