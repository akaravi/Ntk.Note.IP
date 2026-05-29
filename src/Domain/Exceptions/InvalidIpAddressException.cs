namespace Ntk.Note.IP.Domain.Exceptions;

public class InvalidIpAddressException(string value) : Exception($"The value '{value}' is not a valid IP address.")
{
    public string Value { get; } = value;
}
