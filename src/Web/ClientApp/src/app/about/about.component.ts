import { Component, inject } from '@angular/core';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-about',
  templateUrl: './about.component.html',
  styleUrls: ['../static/static-page.scss'],
})
export class AboutComponent {
  readonly i18n = inject(I18nService);
  readonly year = new Date().getFullYear();
}
