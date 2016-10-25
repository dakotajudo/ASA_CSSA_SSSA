plot.lsmeans <- function(model,formula=NULL,title="lm") {
   if(is.null(formula)) {
      formula <- cld ~ trt
   }
   model.tbl <- lsmeans(model,cld ~ trt)
   dodge <- position_dodge(width = 0.9)
   upper.lim <- max(model.tbl$lsmean)
   upper.se <- max(model.tbl$SE)
   limits <- aes(ymax = model.tbl$lsmean + model.tbl$SE,
      ymin = model.tbl$lsmean - model.tbl$SE)
   letters <- cld(glht(model,linfct=mcp(trt="Tukey")))$mcletters$monospacedLetters
   #letters <- cld(glht(model,linfct=mcp(trt="Tukey")))$mcletters$Letters
   return(ggplot(data = model.tbl, aes(x = trt, y = lsmean, fill = trt)) + 
     geom_bar(stat = "identity", position = dodge) +
     coord_cartesian(ylim = c(min(model.tbl$lsmean) - 3/2*(model.tbl$SE), 
                              max(model.tbl$lsmean) + 3/2*(model.tbl$SE))) +
     geom_errorbar(limits, position = dodge, width = 0.25) +
     theme(legend.position = "none") + ggtitle(title) + scale_fill_manual(values=cbbPalette) +
     geom_text(aes(x=model.tbl$trt,y=upper.lim+1.25*upper.se,label=letters))
   #  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(),
   #        axis.title.x=element_blank())
   )
}