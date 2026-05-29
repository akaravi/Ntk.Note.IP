using Ntk.Note.IP.Application.Common.Models;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Ntk.Note.IP.Web.Infrastructure;

public static class ApiEnvelopeResults
{
    public static Ok<ErrorExceptionResult<T>> Ok<T>(T data) =>
        TypedResults.Ok(ErrorExceptionResult<T>.Ok(data));

    public static Created<ErrorExceptionResult<T>> Created<T>(string uri, T data) =>
        TypedResults.Created(uri, ErrorExceptionResult<T>.Ok(data));

    public static NoContent NoContentSuccess() => TypedResults.NoContent();
}
