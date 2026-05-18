# CHANGELOG do DojoFit

## 0.4.1
* fix: ajuste para o logger no `ExercisesDatasource` e correçaõ do `ServerErrorHandler`

## 0.4.0
* feat: especialização da lógica de mocks no `ExercisesDatasource`
* test: cobertura de cenários de mock (sucesso, erro, lista vazia e filtros específicos)

## 0.3.3
* fix: ajuste de importacao

## 0.3.2

* feat: implementação dos entrypoints (`main_prod` e `main_mock`) para alternância de ambientes
* test: adição de testes unitários para a camada de Network e Datasource
* refactor: ajustes configuração global de injeção de dependência

## 0.3.1

* fix: correção da sintaxe de query parameters no `ExercisesDatasource`
* fix: ajuste no mapeamento do `ExerciseModel` para suportar campos nulos da API (Null Safety)
* test: implementação de testes unitários para o `ExerciseModel` validando a estrutura real da API

## 0.3.0

* feat: implementação da camada de Network (Config, Logger e ErrorHandler) utilizando `pop_network`
* feat: configuração do módulo de injeção de dependências (`ExercisesInjector`) com `auto_injector`
* feat: suporte a carregamento de mocks via `rootBundle` para testes e desenvolvimento offline


## 0.2.0

* feat: implementação da camada Data (Models, DataSources e Repositories Implementation)
* test: adição de testes unitários para o Repository e DataSources
* fix: resolver erro de retorno nulo nos testes do datasource

## 0.1.0

* feat: implementação da camada Domain (Entities, Repository Interface e UseCases)
* test: adição de testes unitários do GetExercisesUseCase (sucesso e erro)