import { Component, inject } from '@angular/core';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-copyright',
  templateUrl: './copyright.component.html',
  styleUrls: ['../static/static-page.scss'],
})
export class CopyrightComponent {
  readonly i18n = inject(I18nService);
  readonly year = new Date().getFullYear();
}
