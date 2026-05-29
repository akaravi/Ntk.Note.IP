import { Component, inject } from '@angular/core';
import { I18nService } from './core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent {
  readonly i18n = inject(I18nService);
  readonly year = new Date().getFullYear();
}
