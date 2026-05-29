using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ntk.Note.IP.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddUserPublicIpSnapshot : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "UserPublicIpSnapshots",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    UserId = table.Column<string>(type: "TEXT", maxLength: 450, nullable: false),
                    Address = table.Column<string>(type: "TEXT", maxLength: 45, nullable: false),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserPublicIpSnapshots", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_UserPublicIpSnapshots_UserId",
                table: "UserPublicIpSnapshots",
                column: "UserId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserPublicIpSnapshots");
        }
    }
}
