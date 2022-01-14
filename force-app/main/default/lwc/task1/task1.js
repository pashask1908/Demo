import { LightningElement, track } from 'lwc';

export default class Task1 extends LightningElement {
  value1;
  value2 
  @track value;

  value1Tracking(event){
    this.value1 = event.target.value;
  }

  value2Tracking(event){
    console.log(event.target);
    this.value2 = event.target.value;
  }

  add() {
    this.value = parseInt(this.value1) + parseInt(this.value2);
    console.log('test 3--'+this.value);
  }

  subtract() {
    this.value = parseInt(this.value1) - parseInt(this.value2);
  }

  multiply() {
    this.value = parseInt(this.value1) * parseInt(this.value2);
    //console.log('test 4--' + this.listValues);
  }
  division() {
    this.value = parseInt(this.value1) / parseInt(this.value2);
  }

}