<TeXmacs|1.99.5>

<style|generic>

<\body>
  <doc-data|<doc-title|Computing dispersion for augmented
  designs.>|<doc-author|<\author-data|<author-name|Peter Claussen>>
    \;
  </author-data>>>

  \;

  van Es, et al, <inactive|<cite|es.h-03-1993>>

  Federer used a simple design to demonstrate the analysis of\ 

  van Es et al, discuss the average distance of comparison (1993) and present
  designs spatially balanced for treatment comparsions, assuming all-pairwise
  contrasts in an RCB design.\ 

  Augmented designs present 3 types of contrasts - between two check
  treatments, between two unreplicated treatments and between a check
  treatment and an unreplicated treatment.

  <subsection|Across Replicates>

  <big-table|<tabular|<tformat|<table|<row|<cell|>>>>><tabular*|<tformat|<table|<row|<cell|Contrast>|<cell|Plot
  1>|<cell|Plot 2>|<cell|Distance>>|<row|<cell|1-2>|<cell|(1,3)>|<cell|(1,6)>|<cell|3.00>>|<row|<cell|1-2>|<cell|(1,3)>|<cell|(2,2)>|<cell|1.41>>|<row|<cell|1-2>|<cell|(1,3)>|<cell|(3,6)>|<cell|3.61>>|<row|<cell|1-2>|<cell|(2,3)>|<cell|(1,6)>|<cell|3.16>>|<row|1-2|<cell|(2,3)>|<cell|(2,2)>|<cell|1.00>>|<row|<cell|1-2>|<cell|(2,3)>|<cell|(3,6)>|<cell|3.16>>|<row|<cell|1-2>|<cell|(3,5)>|<cell|(1,6)>|<cell|2.24>>|<row|<cell|1-2>|<cell|(3,5)>|<cell|(2,2)>|<cell|3.16>>|<row|<cell|1-2>|(3,5)|<cell|(3,6)>|<cell|1.00>>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|1-5>|<cell|(1,3)>|<cell|(2,5)>|<cell|2.24>>|<row|<cell|1-5>|<cell|(2,3)>|<cell|(2,5)>|<cell|2.00>>|<row|<cell|1-5>|<cell|(3,5)>|<cell|(2,5)>|<cell|1.00>>|<row|<cell|1-6>|<cell|(1,3)>|<cell|(1,4)>|<cell|1.00>>|<row|<cell|1-6>|<cell|(2,3)>|<cell|(1,4)>|<cell|1.41>>|<row|<cell|1-6>|<cell|(3,5)>|(1,4)|<cell|2.24>>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|10-11>|<cell|(1,7)>|<cell|(3,7)>|<cell|2.00>>|<row|<cell|10-12>|<cell|(1,7)>|<cell|(3,1)>|<cell|6.32>>|<row|<cell|11-12>|<cell|(3,7)>|<cell|(3,1)>|<cell|6.00>>>>>|Plot-wise
  distances>

  <big-table|<tabular|<tformat|<table|<row|<cell|<tabular|<tformat|<table|<row|<cell|Contrast>>>>>>|<cell|min>|<cell|max>|<cell|count>|<cell|mean>|<cell|sd>>|<row|<cell|1-2>|<cell|1.00>|<cell|3.61>|<cell|9>|<cell|2.42>|<cell|1.03>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|1-5>|<cell|1.00>|<cell|2.24>|<cell|3>|<cell|1.74>|<cell|0.66>>|<row|<cell|1-6>|<cell|1.00>|<cell|2.24>|<cell|3>|<cell|1.55>|<cell|0.63>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|10-11>|<cell|2.00>|<cell|2.00>|<cell|1>|<cell|2.00>|<cell|->>|<row|<cell|10-12>|<cell|6.32>|<cell|6.32>|<cell|1>|<cell|6.32>|<cell|->>|<row|<cell|11-12>|<cell|6.00>|<cell|6.00>|<cell|1>|<cell|6.00>|<cell|->>>>>|Contrast-wise
  distances>

  \;

  <big-table|<tabular|<tformat|<table|<row|<cell|<tabular*|<tformat|<table|<row|<cell|>|<cell|1>|<cell|2>|<cell|<math|\<ldots\>>>|<cell|5>|<cell|6>|<cell|<math|\<ldots\>>>|<cell|10>|<cell|11>|<cell|12>|<cell|>|<cell|mean>|<cell|sd>>|<row|<cell|1>|<cell|->|<cell|2.42>|<cell|>|<cell|1.74>|<cell|1.55>|<cell|>|<cell|3.65>|<cell|3.53>|<cell|3.02>|<cell|>|<cell|2.45>|<cell|0.76>>|<row|<cell|2>|<cell|2.42>|<cell|->|<cell|>|<cell|1.94>|<cell|2.35>|<cell|>|<cell|2.78>|<cell|2.78>|<cell|3.93>|<cell|>|<cell|2.74>|<cell|0.67>>|<row|<cell|<math|\<ldots\>>>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|5>|<cell|1.74>|<cell|1.94>|<cell|>|<cell|->|<cell|1.41>|<cell|>|<cell|2.24>|<cell|2.24>|<cell|4.12>|<cell|>|<cell|2.28>|<cell|1.02>>|<row|<cell|6>|<cell|1.55>|<cell|2.35>|<cell|>|<cell|1.41>|<cell|->|<cell|>|<cell|3.00>|<cell|3.61>|<cell|3.61>|<cell|>|<cell|2.44>|<cell|0.76>>|<row|<cell|<math|\<ldots\>>>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|10>|<cell|3.65>|<cell|2.78>|<cell|>|<cell|2.24>|<cell|3.00>|<cell|>|<cell|->|<cell|2.00>|<cell|6.32>|<cell|>|<cell|3.61>|<cell|1.57>>|<row|<cell|11>|<cell|3.53>|<cell|2.78>|<cell|>|<cell|2.24>|<cell|3.61>|<cell|>|<cell|2.00>|<cell|->|<cell|6.00>|<cell|>|<cell|3.61>|<cell|1.57>>|<row|<cell|12>|<cell|3.02>|<cell|3.93>|<cell|>|<cell|4.12>|<cell|3.61>|<cell|>|<cell|6.32>|<cell|6.00>|<cell|->|<cell|>|<cell|3.79>|<cell|1.48>>>>>>>>>>|Treatment
  distances>

  \;

  <subsection|Within Replicate>

  <big-table|<tabular|<tformat|<table|<row|<cell|>>>>><tabular*|<tformat|<table|<row|<cell|Contrast>|<cell|Plot
  1>|<cell|Plot 2>|<cell|Distance>>|<row|<cell|1-2>|<cell|(1,3)>|<cell|(1,6)>|<cell|3.00>>|<row|<cell|1-2>|<cell|(1,3)>|<cell|(2,2)>|<cell|->>|<row|<cell|1-2>|<cell|(1,3)>|<cell|(3,6)>|<cell|->>|<row|<cell|1-2>|<cell|(2,3)>|<cell|(1,6)>|<cell|->>|<row|1-2|<cell|(2,3)>|<cell|(2,2)>|<cell|1.00>>|<row|<cell|1-2>|<cell|(2,3)>|<cell|(3,6)>|<cell|->>|<row|<cell|1-2>|<cell|(3,5)>|<cell|(1,6)>|<cell|->>|<row|<cell|1-2>|<cell|(3,5)>|<cell|(2,2)>|<cell|->>|<row|<cell|1-2>|(3,5)|<cell|(3,6)>|<cell|1.00>>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|1-5>|<cell|(1,3)>|<cell|(2,5)>|<cell|->>|<row|<cell|1-5>|<cell|(2,3)>|<cell|(2,5)>|<cell|2.00>>|<row|<cell|1-5>|<cell|(3,5)>|<cell|(2,5)>|<cell|->>|<row|<cell|1-6>|<cell|(1,3)>|<cell|(1,4)>|<cell|1.00>>|<row|<cell|1-6>|<cell|(2,3)>|<cell|(1,4)>|<cell|->>|<row|<cell|1-6>|<cell|(3,5)>|(1,4)|<cell|->>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|10-11>|<cell|(1,7)>|<cell|(3,7)>|<cell|->>|<row|<cell|10-12>|<cell|(1,7)>|<cell|(3,1)>|<cell|->>|<row|<cell|11-12>|<cell|(3,7)>|<cell|(3,1)>|<cell|6.00>>>>>|Plot-wise
  distances>

  <big-table|<tabular|<tformat|<table|<row|<cell|<tabular|<tformat|<table|<row|<cell|Contrast>>>>>>|<cell|min>|<cell|max>|<cell|count>|<cell|mean>|<cell|sd>>|<row|<cell|1-2>|<cell|1.00>|<cell|3.00>|<cell|3>|<cell|1.67>|<cell|1.15>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|1-5>|<cell|2.00>|<cell|2.00>|<cell|1>|<cell|2.00>|<cell|->>|<row|<cell|1-6>|<cell|1.00>|<cell|1.00>|<cell|1>|<cell|1.00>|<cell|->>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|10-11>|<cell|->|<cell|->|-|<cell|->|<cell|->>|<row|<cell|10-12>|<cell|->|<cell|->|<cell|->|<cell|->|<cell|->>|<row|<cell|11-12>|<cell|6.00>|<cell|6.00>|<cell|1>|<cell|->|<cell|->>>>>|Contrast-wise
  distances>

  \;

  <big-table|<tabular|<tformat|<table|<row|<cell|<tabular*|<tformat|<table|<row|<cell|>|<cell|1>|<cell|2>|<cell|<math|\<ldots\>>>|<cell|5>|<cell|6>|<cell|<math|\<ldots\>>>|<cell|10>|<cell|11>|<cell|12>|<cell|>|<cell|count>|<cell|mean>|<cell|sd>>|<row|<cell|1>|<cell|->|<cell|1.67>|<cell|>|<cell|2.00>|<cell|1.00>|<cell|>|<cell|4.00>|<cell|2.00>|<cell|4.00>|<cell|>|<cell|11>|<cell|2.21>|<cell|1.04>>|<row|<cell|2>|<cell|1.67>|<cell|->|<cell|>|<cell|3.00>|<cell|2.00>|<cell|>|<cell|1.00>|<cell|1.00>|<cell|5.00>|<cell|>|<cell|11>|<cell|2.70>|<cell|1.47>>|<row|<cell|<math|\<ldots\>>>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|5>|<cell|2.00>|<cell|3.00>|<cell|>|<cell|->|<cell|->|<cell|>|<cell|->|<cell|->|<cell|->|<cell|>|<cell|5>|<cell|2.20>|<cell|1.30>>|<row|<cell|6>|<cell|1.00>|<cell|2.00>|<cell|>|<cell|->|<cell|->|<cell|>|<cell|3.0>|<cell|->|<cell|->|<cell|>|<cell|6>|<cell|2.00>|<cell|0.89>>|<row|<cell|<math|\<ldots\>>>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|10>|<cell|4.00>|<cell|1.00>|<cell|>|<cell|->|<cell|3.0>|<cell|>|<cell|->|<cell|->|<cell|->|<cell|>|<cell|6>|<cell|3.5>|<cell|1.87>>|<row|<cell|11>|<cell|2.00>|<cell|1.00>|<cell|>|<cell|->|-|<cell|>|<cell|->|<cell|->|<cell|6.00>|<cell|>|<cell|6>|<cell|3.5>|<cell|1.87>>|<row|<cell|12>|<cell|4.00>|<cell|5.00>|<cell|>|<cell|->|<cell|->|<cell|>|<cell|->|<cell|6.00>|<cell|->|<cell|>|<cell|6>|<cell|3.5>|<cell|1.87>>>>>>>>>>|Treatment
  distances>

  <subsection|Within Replicate, Mixed Contrast Only>

  <big-table|<tabular|<tformat|<table|<row|<cell|>>>>><tabular*|<tformat|<table|<row|<cell|Contrast>|<cell|Plot
  1>|<cell|Plot 2>|<cell|Distance>>|<row|<cell|1-2>|<cell|(1,3)>|<cell|(1,6)>|<cell|->>|<row|<cell|1-2>|<cell|(1,3)>|<cell|(2,2)>|<cell|->>|<row|<cell|1-2>|<cell|(1,3)>|<cell|(3,6)>|<cell|->>|<row|<cell|1-2>|<cell|(2,3)>|<cell|(1,6)>|<cell|->>|<row|1-2|<cell|(2,3)>|<cell|(2,2)>|<cell|->>|<row|<cell|1-2>|<cell|(2,3)>|<cell|(3,6)>|<cell|->>|<row|<cell|1-2>|<cell|(3,5)>|<cell|(1,6)>|<cell|->>|<row|<cell|1-2>|<cell|(3,5)>|<cell|(2,2)>|<cell|->>|<row|<cell|1-2>|(3,5)|<cell|(3,6)>|<cell|->>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|1-5>|<cell|(1,3)>|<cell|(2,5)>|<cell|->>|<row|<cell|1-5>|<cell|(2,3)>|<cell|(2,5)>|<cell|2.00>>|<row|<cell|1-5>|<cell|(3,5)>|<cell|(2,5)>|<cell|->>|<row|<cell|1-6>|<cell|(1,3)>|<cell|(1,4)>|<cell|1.00>>|<row|<cell|1-6>|<cell|(2,3)>|<cell|(1,4)>|<cell|->>|<row|<cell|1-6>|<cell|(3,5)>|(1,4)|<cell|->>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|10-11>|<cell|(1,7)>|<cell|(3,7)>|<cell|->>|<row|<cell|10-12>|<cell|(1,7)>|<cell|(3,1)>|<cell|->>|<row|<cell|11-12>|<cell|(3,7)>|<cell|(3,1)>|<cell|->>>>>|Plot-wise
  distances>

  <big-table|<tabular|<tformat|<table|<row|<cell|<tabular|<tformat|<table|<row|<cell|Contrast>>>>>>|<cell|min>|<cell|max>|<cell|count>|<cell|mean>|<cell|sd>>|<row|<cell|1-2>|<cell|->|<cell|->|<cell|->|<cell|->|<cell|->>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|1-5>|<cell|2.00>|<cell|2.00>|<cell|1>|<cell|2.00>|<cell|->>|<row|<cell|1-6>|<cell|1.00>|<cell|1.00>|<cell|1>|<cell|1.00>|<cell|->>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|10-11>|<cell|->|<cell|->|-|<cell|->|<cell|->>|<row|<cell|10-12>|<cell|->|<cell|->|<cell|->|<cell|->|<cell|->>|<row|<cell|11-12>|<cell|->|<cell|->|<cell|->|<cell|->|<cell|->>>>>|Contrast-wise
  distances>

  \;

  <big-table|<tabular|<tformat|<table|<row|<cell|<tabular*|<tformat|<table|<row|<cell|>|<cell|1>|<cell|2>|<cell|<math|\<ldots\>>>|<cell|5>|<cell|6>|<cell|<math|\<ldots\>>>|<cell|10>|<cell|11>|<cell|12>|<cell|>|<cell|count>|<cell|mean>|<cell|sd>>|<row|<cell|1>|<cell|->|<cell|>|<cell|>|2.00|<cell|1.00>|<cell|>|<cell|4.00>|<cell|2.00>|<cell|4.00>|<cell|>|<cell|8>|<cell|2.375>|<cell|1.188>>|<row|<cell|2>|<cell|>|<cell|->|<cell|>|<cell|3.00>|<cell|2.00>|<cell|>|<cell|1.00>|<cell|1.00>|<cell|5.00>|<cell|>|<cell|8>|<cell|2.875>|<cell|1.642>>|<row|<cell|<math|\<ldots\>>>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|5>|<cell|2.00>|<cell|3.00>|<cell|>|<cell|->|<cell|->|<cell|>|<cell|->|<cell|->|<cell|->|<cell|>|<cell|4>|<cell|2.5>|<cell|1.291>>|<row|<cell|6>|<cell|1.00>|<cell|2.00>|<cell|>|<cell|->|<cell|->|<cell|>|<cell|>|<cell|->|<cell|->|<cell|>|<cell|4>|<cell|1.5>|<cell|0.588>>|<row|<cell|<math|\<ldots\>>>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|10>|<cell|4.00>|<cell|1.00>|<cell|>|<cell|->|<cell|>|<cell|>|<cell|->|<cell|->|<cell|->|<cell|>|<cell|4>|<cell|3.0>|<cell|1.826>>|<row|<cell|11>|<cell|2.00>|<cell|1.00>|<cell|>|<cell|->|-|<cell|>|<cell|->|<cell|->|<cell|->|<cell|>|<cell|4>|<cell|3.0>|<cell|1.826>>|<row|<cell|12>|<cell|4.00>|<cell|5.00>|<cell|>|<cell|->|<cell|->|<cell|>|<cell|->|<cell|->|<cell|->|<cell|>|<cell|4>|<cell|3.0>|<cell|1.826>>>>>>>>>>|Treatment
  distances>

  <\bibliography|bib|tm-plain|biblio.bib>
    <bib-list|0|>
  </bibliography>
</body>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-10|<tuple|7|?>>
    <associate|auto-11|<tuple|8|?>>
    <associate|auto-12|<tuple|9|?>>
    <associate|auto-13|<tuple|9|?>>
    <associate|auto-14|<tuple|9|?>>
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-3|<tuple|2|?>>
    <associate|auto-4|<tuple|3|?>>
    <associate|auto-5|<tuple|2|?>>
    <associate|auto-6|<tuple|4|?>>
    <associate|auto-7|<tuple|5|?>>
    <associate|auto-8|<tuple|6|?>>
    <associate|auto-9|<tuple|3|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|table>
      <tuple|normal|Plot-wise distances|<pageref|auto-3>>

      <tuple|normal|Contrast-wise distances|<pageref|auto-4>>

      <tuple|normal|Treatment distances|<pageref|auto-5>>

      <tuple|normal|Plot-wise distances|<pageref|auto-7>>

      <tuple|normal|Contrast-wise distances|<pageref|auto-8>>

      <tuple|normal|Treatment distances|<pageref|auto-9>>

      <tuple|normal|Plot-wise distances|<pageref|auto-11>>

      <tuple|normal|Contrast-wise distances|<pageref|auto-12>>

      <tuple|normal|Treatment distances|<pageref|auto-13>>
    </associate>
    <\associate|toc>
      <with|par-left|<quote|1tab>|Computing dispersion for augmented designs.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1>>

      <with|par-left|<quote|1tab>|1<space|2spc>Across Replicates
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>>

      <with|par-left|<quote|1tab>|2<space|2spc>Within Replicate
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1tab>|3<space|2spc>Within Replicate, Mixed
      Contrast Only <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Bibliography>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>