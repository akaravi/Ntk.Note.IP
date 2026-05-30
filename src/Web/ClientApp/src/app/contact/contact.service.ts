import { HttpClient } from '@angular/common/http';
import { Inject, Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import { apiV1Group } from '../core/api-routes';
import { API_BASE_URL } from '../web-api-client';
import { ErrorExceptionResult } from '../ip-lookup/ip-lookup.service';

export interface ContactSubmissionResultDto {
  ticketId: number;
  emailSent: boolean;
}

export interface AddContactSubmissionRequest {
  name: string;
  email: string;
  subject: string;
  message: string;
}

@Injectable({ providedIn: 'root' })
export class ContactService {
  private readonly base: string;

  constructor(
    private readonly http: HttpClient,
    @Inject(API_BASE_URL) baseUrl: string
  ) {
    this.base = `${baseUrl}${apiV1Group('Contact')}`;
  }

  submit(request: AddContactSubmissionRequest): Observable<ContactSubmissionResultDto> {
    return this.http
      .post<ErrorExceptionResult<ContactSubmissionResultDto>>(this.base, request)
      .pipe(
        map((result) => {
          if (!result.isSuccess || !result.data) {
            throw new Error(result.errorMessage ?? 'Submit failed');
          }
          return result.data;
        })
      );
  }
}
