<TeXmacs|1.99.2>

<style|generic>

<\body>
  <doc-data|<doc-title|Meta Analysis session>|<doc-author|<\author-data|<author-name|>>
    \;
  </author-data>>>

  <\definition>
    Analysis of results from multiple independent studies
  </definition>

  Studies may not necessarily be independent, since previous studies provide
  the basis for new studies

  Study results vs. individual observations

  Sampling variance <math|s<rsup|2>>

  - can be computed from SE, LSD, approximated from CLD

  Effect size <math|z>

  For meta analysis, each study must provide <math|s<rsup|2>> and <math|z>.

  *forest plot

  Methods

  <\enumerate-alpha>
    <item>Method of Moments

    <\enumerate-roman>
      <item>Equate Cochran's <math|Q> statistics to it's expected value and
      solve for <math|\<sigma\><rsup|2>>

      <item>DerSimonian and Laird (1986) method

      <item>CMA by Biostat

      <item>Borenstein et al 2009
    </enumerate-roman>

    <item>Maximum Likelihood and REML\ 

    <\enumerate-roman>
      <item>iterative
    </enumerate-roman>

    <item>Bayesian analysis
  </enumerate-alpha>

  References

  Hunter and Schmidt 2004

  Piepho (Peefo) 2014 Biom J - two-stage approach

  Riley (Stat Med 2009)

  Shah and Dillard Plant Disease 90 2006 - use this as a test case

  \;

  For ARM

  <\itemize-dot>
    <item>Appropriate analysis in primary study.

    <item>ST-Meta

    <\itemize-minus>
      <item>Moderator variables

      <item>Single trials hold observations, AOV record

      <item>screening tools
    </itemize-minus>

    <item>
  </itemize-dot>

  \;

  Cochrane Collaboration as model for variety trials
</body>