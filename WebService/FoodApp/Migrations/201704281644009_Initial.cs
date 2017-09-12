namespace FoodApp.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.FoodItems",
                c => new
                    {
                        ProductId = c.Int(nullable: false),
                        UserId = c.Int(nullable: false),
                        ProductName = c.String(),
                        Weight = c.Int(nullable: false),
                        Price = c.Double(nullable: false),
                        Purchased = c.DateTime(nullable: false),
                        Expiry = c.DateTime(nullable: false),
                        Priority = c.Int(nullable: false),
                        AmountRemaining = c.Int(nullable: false),
                        inFridge = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => new { t.ProductId, t.UserId });
            
            CreateTable(
                "dbo.Users",
                c => new
                    {
                        UserId = c.Int(nullable: false),
                        Email = c.String(),
                        firstName = c.String(),
                        lastName = c.String(),
                        Password = c.String(),
                    })
                .PrimaryKey(t => t.UserId);
            
            CreateTable(
                "dbo.Wastes",
                c => new
                    {
                        Timestamp = c.DateTime(nullable: false),
                        UserId = c.Int(nullable: false),
                        Weight = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.Timestamp, t.UserId });
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Wastes");
            DropTable("dbo.Users");
            DropTable("dbo.FoodItems");
        }
    }
}
