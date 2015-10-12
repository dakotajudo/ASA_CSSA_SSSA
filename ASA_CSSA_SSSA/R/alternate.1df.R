alternate.tukey.1df <- function(data,AName="TrtNo",
                                BName="Trial.ID",
                                response="values") {
  tdf <- tukey.1df.ARMST(data=data,AName=AName,
                         BName=BName,
                         response=response)
  
  form1 <- paste(response, "~", AName, "+", BName, "+ I(a.star/b.star)")
  form2 <- paste(response, "~", AName, "+", BName, "+ I(b.star/a.star)")
  
  lm1 <- lm(form1, data=tdf$lm$model)
  lm2 <- lm(form2, data=tdf$lm$model)
  return(list(t1df=tdf,
              alt1=lm1,
              alt2=lm2))
}