using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ntk.Note.IP.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddIpNoteUserIndexes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_IpNotes_CreatedBy",
                table: "IpNotes",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_IpNotes_CreatedBy_Created",
                table: "IpNotes",
                columns: new[] { "CreatedBy", "Created" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_IpNotes_CreatedBy",
                table: "IpNotes");

            migrationBuilder.DropIndex(
                name: "IX_IpNotes_CreatedBy_Created",
                table: "IpNotes");
        }
    }
}
