using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ntk.Note.IP.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddIpNoteSnapshotMetadata : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Asn",
                table: "IpNotes",
                type: "TEXT",
                maxLength: 256,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "City",
                table: "IpNotes",
                type: "TEXT",
                maxLength: 120,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ClientTimezone",
                table: "IpNotes",
                type: "TEXT",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "CountryCode",
                table: "IpNotes",
                type: "TEXT",
                maxLength: 8,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DeviceInfoJson",
                table: "IpNotes",
                type: "TEXT",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DeviceLabel",
                table: "IpNotes",
                type: "TEXT",
                maxLength: 200,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "IpSnapshotJson",
                table: "IpNotes",
                type: "TEXT",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Isp",
                table: "IpNotes",
                type: "TEXT",
                maxLength: 256,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "LocalIpAddress",
                table: "IpNotes",
                type: "TEXT",
                maxLength: 45,
                nullable: true);

            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "NotedAtClient",
                table: "IpNotes",
                type: "TEXT",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Region",
                table: "IpNotes",
                type: "TEXT",
                maxLength: 120,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Asn",
                table: "IpNotes");

            migrationBuilder.DropColumn(
                name: "City",
                table: "IpNotes");

            migrationBuilder.DropColumn(
                name: "ClientTimezone",
                table: "IpNotes");

            migrationBuilder.DropColumn(
                name: "CountryCode",
                table: "IpNotes");

            migrationBuilder.DropColumn(
                name: "DeviceInfoJson",
                table: "IpNotes");

            migrationBuilder.DropColumn(
                name: "DeviceLabel",
                table: "IpNotes");

            migrationBuilder.DropColumn(
                name: "IpSnapshotJson",
                table: "IpNotes");

            migrationBuilder.DropColumn(
                name: "Isp",
                table: "IpNotes");

            migrationBuilder.DropColumn(
                name: "LocalIpAddress",
                table: "IpNotes");

            migrationBuilder.DropColumn(
                name: "NotedAtClient",
                table: "IpNotes");

            migrationBuilder.DropColumn(
                name: "Region",
                table: "IpNotes");
        }
    }
}
