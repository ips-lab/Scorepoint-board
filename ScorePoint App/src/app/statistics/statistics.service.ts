import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';
import { Observable } from 'rxjs/Observable';

@Injectable()
export class StatisticsService {
	private baseUrl: string = 'https://scorepoint-cm.herokuapp.com';
	// private baseUrl: string = 'http://localhost:3000';

	constructor(private http: Http) { }
  
	getTotalUsers() {
		return this.http
		.get(`${this.baseUrl}/statistics/totalUsers`)
		.map((response: Response) => <DataTotalCountResponse []>response.json().data)
		// .do(data => console.log(data))
		.catch(this.handeError);
	}

	getMostWinners() {
		return this.http
		.get(`${this.baseUrl}/statistics/mostWinners`)
		.map((response: Response) => <DataMostWinnersResponse []>response.json().data)
		// .do(data => console.log(data))
		.catch(this.handeError);
	}

	getTotalGames() {
		return this.http
		.get(`${this.baseUrl}/statistics/totalGames`)
		.map((response: Response) => <DataTotalCountResponse []>response.json().data)
		// .do(data => console.log(data))
		.catch(this.handeError);
	}

	getGamesPerHour() {
		return this.http
		.get(`${this.baseUrl}/statistics/gamesPerHour`)
		.map((response: Response) => <DataTotalGamesResponse []>response.json().data)
		// .do(data => console.log(data))
		.catch(this.handeError);
	}

	private handeError(error:Response) {
		console.log(error);
		let message = `Error status code ${error.status} at ${error.url}`;
		return Observable.throw(message);
	}
}

export interface DataTotalCountResponse {
    data: Count[];
    code: string;
}

export interface Count {
    total: number;
}

export interface DataTotalGamesResponse {
    data: HourGame[];
    code: string;
}

export interface HourGame {
    hour: number;
	total: number;
}

export interface DataMostWinnersResponse {
    data: MostWinners[];
    code: string;
}

export interface MostWinners {
    team: string;
	total: number;
}
