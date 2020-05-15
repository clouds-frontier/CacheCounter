import { LightningElement,wire,track } from 'lwc';
import getOpenTaskCount from '@salesforce/apex/taskCounter.getOpenTaskCount';

export default class taskCounter extends LightningElement {
counter;
error;


  @wire(getOpenTaskCount) wiredCounter
  ({ error, data }) {
    if (data) {
        this.counter = data;
    } else if (error) {
        console.log(error);
        this.error = error;
    } ;
  
 
}
}