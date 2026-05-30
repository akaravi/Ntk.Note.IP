import { Component, ChangeDetectorRef, inject } from '@angular/core';
import { I18nService } from '../core/i18n.service';
import { ContactService } from './contact.service';
import { firstValueFrom } from 'rxjs';

@Component({
  standalone: false,
  selector: 'app-contact',
  templateUrl: './contact.component.html',
  styleUrls: ['../static/static-page.scss', './contact.component.scss'],
})
export class ContactComponent {
  readonly i18n = inject(I18nService);
  private readonly contact = inject(ContactService);
  private readonly cdr = inject(ChangeDetectorRef);

  name = '';
  email = '';
  subject = '';
  message = '';
  submitting = false;
  error: string | null = null;
  success: string | null = null;

  async submit(): Promise<void> {
    this.error = null;
    this.success = null;
    this.submitting = true;
    this.cdr.detectChanges();

    try {
      const result = await firstValueFrom(
        this.contact.submit({
          name: this.name.trim(),
          email: this.email.trim(),
          subject: this.subject.trim(),
          message: this.message.trim(),
        })
      );

      this.success = result.emailSent
        ? this.i18n.t('CONTACT.SUCCESS')
        : this.i18n.t('CONTACT.SUCCESS_NO_EMAIL');
      this.name = '';
      this.subject = '';
      this.message = '';
    } catch (err) {
      this.error = err instanceof Error ? err.message : this.i18n.t('CONTACT.ERROR');
    } finally {
      this.submitting = false;
      this.cdr.detectChanges();
    }
  }
}
