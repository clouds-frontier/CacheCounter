import { LightningElement,wire,track, api } from 'lwc';
import getOpenTaskCount from '@salesforce/apex/taskCounter.getOpenTaskCount';
import {refreshApex} from '@salesforce/apex';

export default class taskCounter extends LightningElement {
counter;
error;
wiredMessages;  

    @wire(getOpenTaskCount) 
    wiredCounter(value) {
        
          this.wiredMessages = value;
          const {data, error} = value;

          if(data){
            this.counter  = data;
            setInterval(()=>{  
              console.log('in SI');
    
              return refreshApex(this.wiredMessages);  
                
            }, 1000);
          }
    
         else if (error) {
            console.log(error);
            this.error = error;
           
        } ;
      }
  
 

}