<TeXmacs|1.99.2>

<style|<tuple|article|std-latex>>

<\body>
  <\hide-preamble>
    <assign|*|<macro|<UTFviiidefined>>>

    <assign|enoteheading|<macro|>>

    <assign|the-footnote|<macro|<number|<footnote-nr>|arabic>>>

    <assign|theendnote|<macro|<number|<endnote-nr>|arabic>>>

    <assign|enotesize|<macro|>>

    <\assign|enoteformat>
      <\macro>
        <left-aligned|<leftskip>=1.8em <makebox>*0pt[r]<theenmark>.
        <rule|0pt|<dimexpr><tmht><strutbox>+<baselineskip>>>
      </macro>
    </assign>
  </hide-preamble>

  <doc-data|<doc-title|Exploring Treatment By Trial Interaction Using
  Treatment Stability/Trial DendrogramPlots>|<doc-date|March 22, 2016>>

  <section|Software Overview><label|MPSection:A30ADD8B-B099-4BDD-96B6-1A96E1942AAF>

  <subsection|ARM><label|MPSection:A59A8EF2-B913-4CC5-AEAE-94014F09998A>

  Single trial management and analysis

  <subsection|ARM ST><label|MPSection:1C2D6F72-E390-47AB-93D5-751C90D169B6>

  Summarizes ARM trials across locations and years

  Treatment means and treatment-trial interaction

  Standard report format

  <section|Standard Report Format><label|MPSection:0B7F4263-E4DC-4C11-870B-853ABE48507A>

  Treatment specific statistics

  Summary Statistics

  Analysis of Variance

  <section|Treatment x Trial Graph><label|MPSection:A32047DB-3AC1-4DEA-C38A-FDDA2EB5B652>

  <resizebox|488px|348px|<image|manuscript-1.eps||||>>

  Treatment Stability

  Trial Dendrogram

  <section|Statistical Model, Multiple Trials><label|MPSection:E18AF5ED-4250-4DA4-8DB9-48E093C3C3E7>

  <\MPEquation|!ht>
    <\equation>
      y<rsub|i*j*k>=\<mu\>+\<alpha\><rsub|i>+\<beta\><rsub|j>+\<theta\><rsub|i*j>+\<rho\><rsub|j*k>+e<rsub|i*j*k>
    </equation>

    <label|MPEquationElement:FEB61892-2AA4-4B4E-A090-F8A291E792E5>
  </MPEquation>

  plot assessment is the sum of

  <\itemize>
    <item>grand mean

    <item><em|i<rsup|th>> treatment

    <item><em|j<rsup|th>> trial

    <item><em|i<rsup|th>> treatment x trial interaction

    <item><em|k<rsup|th>> block in <em|j<rsup|th>> trial

    <item>experimental error
  </itemize>

  <section|Decomposition of Interaction><label|MPSection:C16879C8-07BF-4803-BC89-0EE616697BA1>

  <\itemize>
    <item>Simple additivity

    <\itemize>
      <item><math|\<theta\><rsub|11>=\<theta\><rsub|12>=\<ldots\>=\<theta\><rsub|m*n>=0>
    </itemize>

    <item>Proportional to product of main effects (Tukey 1949)

    <\itemize>
      <item><math|\<theta\><rsub|i*j>=\<lambda\>*\<alpha\><rsub|i>*\<beta\><rsub|j>+e<rsub|i*j>>

      <item>In this case,

      <item><math|e<rsub|i*j>> is a lack of fit random variable, while l is a
      fixed effect that is determine by the specific combinations of
      treatments and trials.

      <item>This would suggest that, if were to repeat a series of
      experiments with similar (perhaps identical) treatments and similar
      environments, we would obtain a similar estimate of l.

      <item>Otherwise, we might model l as a random variable that is unique
      to a combination of treatments and trials.
    </itemize>

    <item>Proportional to one main (trial) effect (Mandel 1961)

    <\itemize>
      <item><math|\<theta\><rsub|i*j>=\<lambda\><rsub|i>*\<beta\><rsub|j>+e<rsub|i*j>>

      <item>Since this is an effect associated with each treatment, this
      should be fixed when treatment is fixed, and random when treatment is
      random. If fixed, we should expect that repeated experiments produce
      comparable values.
    </itemize>

    <item>Other decompositions cite (Milliken and Johnson 1989 (Cornelius et
    al. 2001)
  </itemize>

  <section|Bibliography><label|MPSection:18A2900B-CF97-4856-8B2F-F5B0136AF97B>

  Mandel, J., 1961. Non-additivity in the Two-Way Analysis of Variance.
  <em|Journal of the American Statistical Association>, 56(296).

  Tukey, J.W., 1949. One Degree of Freedom for Non-Additivity.
  <em|Biometrics>, 5(3).
</body>

<\initial>
  <\collection>
    <associate|page-orientation|portrait>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|MPEquationElement:FEB61892-2AA4-4B4E-A090-F8A291E792E5|<tuple|1|?>>
    <associate|MPSection:0B7F4263-E4DC-4C11-870B-853ABE48507A|<tuple|2|?>>
    <associate|MPSection:18A2900B-CF97-4856-8B2F-F5B0136AF97B|<tuple|6|?>>
    <associate|MPSection:1C2D6F72-E390-47AB-93D5-751C90D169B6|<tuple|1.2|?>>
    <associate|MPSection:A30ADD8B-B099-4BDD-96B6-1A96E1942AAF|<tuple|1|?>>
    <associate|MPSection:A32047DB-3AC1-4DEA-C38A-FDDA2EB5B652|<tuple|3|?>>
    <associate|MPSection:A59A8EF2-B913-4CC5-AEAE-94014F09998A|<tuple|1.1|?>>
    <associate|MPSection:C16879C8-07BF-4803-BC89-0EE616697BA1|<tuple|5|?>>
    <associate|MPSection:E18AF5ED-4250-4DA4-8DB9-48E093C3C3E7|<tuple|4|?>>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-2|<tuple|1.1|?>>
    <associate|auto-3|<tuple|1.2|?>>
    <associate|auto-4|<tuple|2|?>>
    <associate|auto-5|<tuple|3|?>>
    <associate|auto-6|<tuple|4|?>>
    <associate|auto-7|<tuple|5|?>>
    <associate|auto-8|<tuple|6|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Software
      Overview> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <with|par-left|<quote|1tab>|1.1<space|2spc>ARM
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>>

      <with|par-left|<quote|1tab>|1.2<space|2spc>ARM ST
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Standard
      Report Format> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Treatment
      x Trial Graph> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Statistical
      Model, Multiple Trials> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>Decomposition
      of Interaction> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|6<space|2spc>Bibliography>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>