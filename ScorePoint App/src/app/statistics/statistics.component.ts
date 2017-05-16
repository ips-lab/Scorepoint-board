import {Component, OnInit} from '@angular/core';
import { StatisticsService } from './statistics.service';

@Component({
  selector: 'statistics',
  styleUrls: ['./statistics.component.css'],
  templateUrl: './statistics.component.html',
  providers: [StatisticsService]
})
export class StatisticsComponent implements OnInit {
  constructor(private statisticService: StatisticsService) {}

  totalUsers = [];
  hourGame = [];
  totalGames = [];
  mostWinners = [];

  ngOnInit() {
    this.statisticService.getTotalUsers().subscribe(
      data => this.totalUsers = data,
			err => err
      // ,() => console.log(this.totalUsers)
    );
    this.statisticService.getGamesPerHour().subscribe(
      data => this.hourGame = data,
			err => err
      ,() => console.log(this.hourGame)
    );
    this.statisticService.getTotalGames().subscribe(
      data => this.totalGames = data,
			err => err
      // ,() => console.log(this.totalGames)
    );
    this.statisticService.getMostWinners().subscribe(
      data => this.mostWinners = data,
			err => err
      // ,() => console.log(this.mostWinners)
    );
	}
}
