import { Routes } from '@angular/router';

import { StatisticsComponent } from './statistics/statistics.component';
import { HomeComponent } from './home/home.component';
export const rootRouterConfig: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'home', component: HomeComponent },
  { path: 'statistics', component: StatisticsComponent }
];

