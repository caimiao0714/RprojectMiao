
library(DiagrammeR)
grViz("digraph flowchart {
      # node definitions with substituted label text
      node [fontname = Helvetica, shape = rectangle]
      tab1 [label = '@@1']
      tab2 [label = '@@2']
      tab3 [label = '@@3']
      tab4 [label = '@@4']
      tab5 [label = '@@5']

      # edge definitions with the node IDs
      tab1 -> tab2;
      tab2 -> tab3;
      tab2 -> tab4 -> tab5
      }

      [1]: 'Questionnaire sent to n=1000 participants'
      [2]: 'Participants came to clinic for evaluation n=700'
      [3]: 'Participants non-eligible for the study n=100'
      [4]: 'Participants eligible for the study n=600'
      [5]: 'Study sample n=600'
      ")





p =  grViz("digraph flowchart {
      # node definitions with substituted label text
      node [fontname = Helvetica, shape = rectangle]
      tab1 [label = '@@1']
      tab2 [label = '@@2']
      tab3 [label = '@@3']
      tab4 [label = '@@4']
      tab5 [label = '@@5']

      # edge definitions with the node IDs
      tab1 -> tab2;
      tab2 -> tab3;
      tab2 -> tab4 -> tab5
      }

      [1]: 'Questionnaire sent to n=1000 participants'
      [2]: 'Participants came to clinic for evaluation n=700'
      [3]: 'Participants non-eligible for the study n=100'
      [4]: 'Participants eligible for the study n=600'
      [5]: 'Study sample n=600'
      ")
