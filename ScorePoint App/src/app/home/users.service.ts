import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';
import { Observable } from 'rxjs/Observable';

@Injectable()
export class UsersService {
	private baseUrl: string = 'https://scorepoint-cm.herokuapp.com';
	// private baseUrl: string = 'http://localhost:3000';

	constructor(private http: Http) { }
  
	getAllUsers() {
		return this.http
		.get(`${this.baseUrl}/user`)
		.map((response: Response) => <DataResponse[]>response.json().data)
		// .do(data => console.log(data))
		.catch(this.handeError);
	}

	private handeError(error:Response) {
		console.log(error);
		let message = `Error status code ${error.status} at ${error.url}`;
		return Observable.throw(message);
	}
}

export interface DataResponse {
    data: User[];
    code: string;
}

export interface User {
    userId: number;
    username: string;
    email: string;
    firstname: string;
    lastname: string;
    teamId: number;
    teamname: string;
}
