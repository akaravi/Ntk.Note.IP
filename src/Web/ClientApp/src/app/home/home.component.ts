import { Component, inject } from '@angular/core';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-home',
  templateUrl: './home.component.html',
})
export class HomeComponent {
  readonly i18n = inject(I18nService);
}
