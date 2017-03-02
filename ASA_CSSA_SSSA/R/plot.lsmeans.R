#plot.lsmeans <- function(model,formula=NULL,title="lm") {
#   if(is.null(formula)) {
#      formula <- cld ~ trt
#   }
#   model.tbl <- lsmeans(model,cld ~ trt)
#   dodge <- position_dodge(width = 0.9)
#   upper.lim <- max(model.tbl$lsmean)
#   upper.se <- max(model.tbl$SE)
#   limits <- aes(ymax = model.tbl$lsmean + model.tbl$SE,
#      ymin = model.tbl$lsmean - model.tbl$SE)
#   letters <- cld(glht(model,linfct=mcp(trt="Tukey")))$mcletters$monospacedLetters
#   #letters <- cld(glht(model,linfct=mcp(trt="Tukey")))$mcletters$Letters
#   return(ggplot(data = model.tbl, aes(x = trt, y = lsmean, fill = trt)) + 
#     geom_bar(stat = "identity", position = dodge) +
#     coord_cartesian(ylim = c(min(model.tbl$lsmean) - 3/2*(model.tbl$SE), 
#                              max(model.tbl$lsmean) + 3/2*(model.tbl$SE))) +
#     geom_errorbar(limits, position = dodge, width = 0.25) +
#     theme(legend.position = "none") + ggtitle(title) + scale_fill_manual(values=cbbPalette) +
#     geom_text(aes(x=model.tbl$trt,y=upper.lim+1.25*upper.se,label=letters))
   #  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(),
   #        axis.title.x=element_blank())
#   )
#}
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2",
               "#D55E00", "#F0E442", "#CC79A7", "#734f80", "#2b5a74", 
               "#004f39", "#787221", "#003959", "#6aaf00", "#663cd3",
               "#000000")
make.plot.table <- function(model,form=NULL,effect=NULL) {
   if(is.null(effect)) {
      effect <- "trt"
   }
   if(is.null(form)) {
      form <- formula(paste("cld ~ ",effect))
   }
   model.tbl <- lsmeans(model,form,model="kenward-roger")
   mcp.list <- list(effect="Tukey")
   names(mcp.list) <- effect
   attr(mcp.list, "interaction_average") <- TRUE
   attr(mcp.list, "covariate_average") <- TRUE
   class(mcp.list) <- "mcp"
   letters <- cld(glht(model,linfct=mcp.list,interaction_average = TRUE, 
                                             covariate_average = TRUE),
                        decreasing=TRUE)$mcletters$Letters
   model.tbl$letters <- letters[model.tbl[,effect]]
   names(model.tbl) <- c("Treatment","Mean","Error","df","Lower","Upper","Group","Letters")
   return(model.tbl)
}
plot.lsmeans.tbl <- function(model.tbl,formula=NULL,title="lm") {
   dodge <- position_dodge(width = 0.9)
   upper.lim <- max(model.tbl$Upper)
   upper.lim <-  upper.lim + 0.1*upper.lim 
   limits <- aes(ymax = model.tbl$Upper, ymin = model.tbl$Lower)
   return(ggplot(data = model.tbl, aes(x = Treatment, y = Mean, fill = Treatment)) + 
     geom_bar(stat = "identity", position = dodge) +
     coord_cartesian(ylim = c(min(model.tbl$Lower),upper.lim)) +
     geom_errorbar(limits, position = dodge, width = 0.25) +
     theme(legend.position = "none") + ggtitle(title) + 
     scale_fill_manual(values=cbPalette) +
     geom_text(aes(x=model.tbl$Treatment,y=upper.lim,label=Letters))
   )
}
plot.lsmeans <- function(model,form=NULL,effect=NULL,title="lm") {
   return(
      plot.lsmeans.tbl(
         make.plot.table(model,form=form,effect=effect),formula=formula,title=title))
}