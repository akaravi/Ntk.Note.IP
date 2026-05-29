namespace Ntk.Note.IP.Application.Common.Models;

/// <summary>
/// Uniform operation result envelope for API and application services.
/// </summary>
public sealed class ErrorExceptionResult<T>
{
    public bool IsSuccess { get; init; }

    public string? ErrorMessage { get; init; }

    public string? ErrorCode { get; init; }

    public T? Data { get; init; }

    public static ErrorExceptionResult<T> Ok(T data) =>
        new() { IsSuccess = true, Data = data };

    public static ErrorExceptionResult<T> Fail(string errorCode, string errorMessage) =>
        new() { IsSuccess = false, ErrorCode = errorCode, ErrorMessage = errorMessage };
}

public sealed class ErrorExceptionResult
{
    public bool IsSuccess { get; init; }

    public string? ErrorMessage { get; init; }

    public string? ErrorCode { get; init; }

    public static ErrorExceptionResult Ok() =>
        new() { IsSuccess = true };

    public static ErrorExceptionResult Fail(string errorCode, string errorMessage) =>
        new() { IsSuccess = false, ErrorCode = errorCode, ErrorMessage = errorMessage };
}
