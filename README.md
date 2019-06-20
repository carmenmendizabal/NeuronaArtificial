# NeuronaArtificial

Trabajo Fin de Titulación para el Grado en Ingeniería de Tecnologías y Servicios de Telecomunicación en la Universidad Politécnica de Madrid.

TUTOR: Pablo Ituero Herrero
TÍTULO: Diseño e implementación en FPGA de una neurona artificial de latencia reducida

RESUMEN:

Este proyecto pertenece al campo del aprendizaje automático, más concretamente al de las redes neuronales artificiales. El objetivo es diseñar, desarrollar e implementar en una FPGA una neurona artificial que forma parte de una red neuronal, en la que se busca minimizar la latencia.

La metodología propuesta es la siguiente:
- En primer lugar, se realiza una fase de estudio bibliográfico de los trabajos existentes en el ámbito de la implementaciones hardware de redes neuronales.
- Para cada componente de la neurona, se realiza una exploración arquitectural de los trabajos previos, con especial énfasis en la paralelización y las topologías de baja latencia.
- Tras la selección de los mejores modelos de cada componente, se realiza una implementación hardware descrita en VHDL.
- A continuación se prueban distintas arquitecturas y para la comparación y selección se utilizará la herramienta de Xilinx Vivado.
- Una vez que se ha seleccionado la arquitectura final para la neurona artificial, se realizará un prototipo de una pequeña red neuronal que sirva de demostrador de la neurona en la placa Nexys4 DDR.

El principal resultado técnico del proyecto será una neurona artificial descrita en VHDL e implementada en la placa Nexys4 DDR que se podrá ser utilizada para construir redes neuronales de baja latencia.

Como resultados formativos, se espera que la estudiante desarrolle sus habilidades ingenieriles en el ámbito del diseño electrónico a nivel RTL y algorítmico. Incluyendo la evaluación de distintas arquitecturas de módulos aritméticos y la comparación y evaluación de modelos completos de redes neuronales. 
