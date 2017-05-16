import {Component, OnInit} from '@angular/core';
import { UsersService } from './users.service';
import { Observable } from 'rxjs/Observable';

@Component({
	selector: 'home',
	styleUrls: ['./home.component.css'],
	templateUrl: './home.component.html',
	providers: [UsersService]
})

export class HomeComponent implements OnInit {
	constructor(private userService: UsersService) {}

	users = [];
	selecteditem: Observable<Object>;

	ngOnInit() {
		this.userService.getAllUsers().subscribe(
			data => this.users = data,
			err => err
			// () => console.log('Complete')
		);
	}

	openUser(item:any, lgModal:any){
		this.selecteditem = item;
		console.log(this.selecteditem);
	}
}
