namespace FoodApp.Migrations
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;
    using FoodApp.Models;

    internal sealed class Configuration : DbMigrationsConfiguration<FoodApp.Models.FoodAppContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
        }

        protected override void Seed(FoodApp.Models.FoodAppContext context)
        {
            context.Users.AddOrUpdate(p => p.firstName,
            new User
            {
                firstName = "Akshay",
                lastName = "Garigiparthy",
                Email = "nagaakshay@hotmail.com",
                Password = "password123"
            }
            );
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method 
            //  to avoid creating duplicate seed data. E.g.
            //
            //    context.People.AddOrUpdate(
            //      p => p.FullName,
            //      new Person { FullName = "Andrew Peters" },
            //      new Person { FullName = "Brice Lambson" },
            //      new Person { FullName = "Rowan Miller" }
            //    );
            //
        }
    }
}
