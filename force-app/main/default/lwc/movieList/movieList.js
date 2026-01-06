import { LightningElement, wire, track } from 'lwc';
import getMovies from '@salesforce/apex/IMDBController.getMovies';

export default class MovieList extends LightningElement {
    @track movies = [];
    enteredText = '';
    searchText = '';
    showText = 'Please Enter a Valid Movie Name';

    handleChange(event)
    {
        this.enteredText=event.target.value;
    }

    handleClick(event)
    {
        this.searchText=this.enteredText;
    }

    @wire(getMovies, {searchText:'$searchText'})
    fetchMovies(result)
    {
        if(result.data)
        {
            let data=JSON.parse(result.data);

            if(data.success)
            {
                this.movies=data.result;
                this.showText='';
            }
            else
            {
                this.movies=[];
                this.showText='Please Enter a Valid Movie Name';
            }
        }

        else if(result.error)
        {
            console.log('Error occured while searching movies: '+result.error);
            this.showText='Error occured while searching movies: '+result.error;
        }
    }

}