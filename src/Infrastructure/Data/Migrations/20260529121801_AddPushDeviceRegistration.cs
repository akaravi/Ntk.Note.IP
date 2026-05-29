using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ntk.Note.IP.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddPushDeviceRegistration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PushDeviceRegistrations",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    DeviceToken = table.Column<string>(type: "TEXT", maxLength: 512, nullable: false),
                    Platform = table.Column<string>(type: "TEXT", maxLength: 16, nullable: false),
                    Created = table.Column<DateTimeOffset>(type: "TEXT", nullable: false),
                    CreatedBy = table.Column<string>(type: "TEXT", nullable: true),
                    LastModified = table.Column<DateTimeOffset>(type: "TEXT", nullable: false),
                    LastModifiedBy = table.Column<string>(type: "TEXT", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PushDeviceRegistrations", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_PushDeviceRegistrations_CreatedBy_DeviceToken",
                table: "PushDeviceRegistrations",
                columns: new[] { "CreatedBy", "DeviceToken" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PushDeviceRegistrations");
        }
    }
}
