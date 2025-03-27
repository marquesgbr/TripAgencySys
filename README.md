# Sistema de Agência de Viagens - Modelo Relacional

(Modelo foi criado antes do atual EER)
## **Tabelas de Entidade**

1. **Cliente**  
   * CPF (PK)  
   * CPFIndicadoPor (FK)  
   * Nome  
   * Telefone  
   * Email  
   * Data\_Registro  
   * Pontos\_Fidelidade  
2. **Dependente**  
   * Nome (PK)  
   * CPFResponsavel (PK, FK)  
   * Idade  
   * Parentesco  
3. **Promocao**  
   * Codigo (PK)  
   * Nome  
   * Desconto  
4. **Pacote**  
   * Codigo (PK)  
   * NomePacote  
   * PrecoBase  
5. **Atividade**  
   * Codigo (PK)  
   * Nome  
   * Descricao  
   * Duracao  
6. **TipoAtividade**  
   * Tipo (PK)  
   * CodAtividade (PK, FK)  
7. **Fornecedor**  
   * CNPJ (PK)  
   * NomeEmpresa  
8. **ContatoFornecedor**  
   * CodFornecedor (PK, FK)  
   * Telefone (PK)  
   * Email (PK)  
9. **FornecedorHospedagem**  
   * CNPJ\_H (PK, FK)  
   * Classificacao  
   * Acomodacao  
10. **FornecedorAlimentacao**  
    * CNPJ\_A (PK, FK)  
    * Classificacao  
    * Servico  
11. **FornecedorEvento**  
    * CNPJ\_E (PK, FK)  
    * Tipo  
    * CapacidadeMaxima  
12. **FornecedorTransporte**  
    * CNPJ\_T (PK, FK)  
    * TipoTransporte  
13. **FrotaTransportadora**  
    * CNPJTransportadora (PK, FK)  
    * Veiculo  
    * Quantidade  
14. **Reserva**  
    * Data\_hora\_reserva (PK)  
    * CPFConsumidor (PK, FK)  
    * CodPacote (PK, FK)  
    * CodPromocao (FK)  
    * Data\_Entrada  
    * Data\_Saida  
    * Data\_Modificacao  
    * Status

## **Tabelas de Relacionamento**

1. **Possui**  
   * CodAtividade (PK, FK)  
   * CodPacote (PK, FK)  
   * CNPJFornecedor (PK, FK)  

- - -

# Sistema de Agência de Viagens - Modelo Objeto Relacional

## Tabelas e Members de Entidade

1. **tb\_cliente**
    * Nested Tables:
        * dependentes
        * clientes\_indicados
    * Member Functions/Procedures:
        * get\_pontos() (MAP)
        * add\_pontos()
        * count\_indicados()
        * get\_categoria()
2. **tb\_promocao**
3. **tb\_pacote**
    * Member Function: get\_preco\_final()
4. **tb\_reserva**
    * Member Function: map\_data\_hora() (MAP)
5. **tb\_atividade**


### Fornecedor
**Tipo Base (Abstrato)**
* Member Functions/Procedures:
    * total\_capac() (abstract; MAP)
    * calc\_faturamento\_potencial()
    * add\_contato()
    * rem\_contato()

**Especializações**

1. **tb\_fornecedor\_hospedagem**
    * total\_capac() (Override)
2. **tb\_fornecedor\_alimentacao**
    * total\_capac() (Override)
3. **tb\_fornecedor\_evento**
    * total\_capac() (Override)
4. **tb\_fornecedor\_transporte**
    * total\_capac() (Override)
    * Member function: upsert\_frota()


1. **ntab\_indicados** (clientes_indicados em **tb\_cliente**)
2. **ntab\_dependentes** (dependentes em **tb\_cliente**)
    * Member Functions: 
        * get\_idade() 
        * compare\_idade() (ORDER)
3. **ntab\_frotas** (frotas em **tb\_fornecedor\_transporte**)

## Tabelas de Relacionamento

* **tb\_possui**
    * Relacionamento N:N:N entre:
        * Fornecedores
        * Pacotes
        * Atividades