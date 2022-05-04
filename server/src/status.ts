import {Pedido} from './pedido';

export class Status implements Pedido {
    public static statusList: Status[] = [];
    cpf: string; // Suppose that order has being unpacked in cpf, cnpj and id
    cnpj: string;
    id: number;
    state: number = 0;

    constructor() {
        this.cpf = "";
        this.cnpj ="";
        this.id = -1;
        this.state = 0; //validation is implicit
    }

    update(order: Status){
        this.cpf = order.cpf;
        this.cnpj = order.cnpj;
        this.id = order.id;
        this.statusVal=0;
    }

}
