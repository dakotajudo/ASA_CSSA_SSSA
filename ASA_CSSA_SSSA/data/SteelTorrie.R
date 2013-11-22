#Steel and Torrie
#Principles and procedures of statistics:
#a biometrical approach
p399 <- do.call(function() {
  return(data.frame(
Trial=as.factor(c("Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", 
                  "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton",
                  "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton",
                  "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton", "Clayton",
                  "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton",
                  "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton",
                  "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton",
                  "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton", "Clinton",
                  "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth",
                  "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth",
                  "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth",
                  "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth", "Plymouth")),

Variety=as.factor(c("Tracy", "Tracy", "Tracy", "Centennial", "Centennial", "Centennial", "N72-137", "N72-137","N72-137", 
                       "N72-3058", "N72-3058", "N72-3058", "N72-3148", "N72-3148", "N72-3148", "R73-81", "R73-81", "R73-81", 
                       "D74-7741", "D74-7741", "D74-7741", "N73-693", "N73-693", "N73-693", "N73-877", "N73-877", "N73-877", 
                       "N73-882", "N73-882", "N73-882", "N73-1102", "N73-1102", "N73-1102", "R75-12", "R75-12", "R75-12", 
                       "Tracy", "Tracy", "Tracy", "Centennial", "Centennial", "Centennial", "N72-137", "N72-137", "N72-137", 
                       "N72-3058", "N72-3058", "N72-3058", "N72-3148", "N72-3148", "N72-3148", "R73-81", "R73-81", "R73-81", 
                       "D74-7741", "D74-7741", "D74-7741", "N73-693", "N73-693", "N73-693", "N73-877", "N73-877", "N73-877", 
                       "N73-882", "N73-882", "N73-882", "N73-1102", "N73-1102", "N73-1102", "R75-12", "R75-12", "R75-12", 
                       "Tracy", "Tracy", "Tracy", "Centennial", "Centennial", "Centennial", "N72-137", "N72-137", "N72-137", 
                       "N72-3058", "N72-3058", "N72-3058", "N72-3148", "N72-3148", "N72-3148", "R73-81", "R73-81", "R73-81", 
                       "D74-7741", "D74-7741", "D74-7741", "N73-693", "N73-693", "N73-693", "N73-877", "N73-877", "N73-877", 
                       "N73-882", "N73-882", "N73-882", "N73-1102", "N73-1102", "N73-1102", "R75-12", "R75-12", "R75-12")),

Yield=c(1178, 1089, 960, 1187, 1180, 1235, 1451, 1177, 1723, 1318, 1012, 990, 1345, 
        1335, 1303, 1175, 1064, 1158, 1111, 1111, 1099, 1388, 1214, 1222, 1254, 1249, 
        1135, 1179, 1247, 1096, 1345, 1265, 1178, 1136, 1161, 1004, 1583, 1841, 1464, 
        1713, 1684, 1378, 1369, 1608, 1647, 1547, 1647, 1603, 1622, 1801, 1929, 1800, 
        1787, 1520, 1820, 1521, 1851, 1464, 1607, 1642, 1775, 1513, 1570, 1673, 1507, 
        1390, 1894, 1547, 1751, 1422, 1393, 1342, 1307, 1365, 1542, 1425, 1475, 1276, 
        1289, 1671, 1420, 1250, 1202, 1407, 1546, 1489, 1724, 1344, 1197, 1319, 1280, 
        1260, 1605, 1583, 1503, 1303, 1656, 1371, 1107, 1398, 1497, 1583, 1586, 1423, 
        1524, 911, 1202, 1012),
 
Rep=as.factor(c(1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 
                   1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 
                   1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 
                   1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 
                   1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 
                   1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 
                   1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 
                   1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 
                   1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3))
))
},as.list(c()))

p399Messy <- do.call(function() {
   p399.dat <- p399
   p399.dat$MAR <- p399.dat$Yield
   p399.dat$MissTrt <- p399.dat$Yield
   p399.dat$MissRep <- p399.dat$Yield
   p399.dat$Unrep <- p399.dat$Yield

   p399.dat$MAR[p399.dat$Trial=="Clayton"][c(3,15,18,25,29)] <- NA
   p399.dat$MAR[p399.dat$Trial=="Plymouth"][c(4,18)] <- NA

   p399.dat$MissTrt[p399.dat$Trial=="Clinton" & p399.dat$Treatment == levels(p399.dat$Treatment)[1]] <- NA
   p399.dat$MissTrt[p399.dat$Trial=="Clinton" & p399.dat$Treatment == levels(p399.dat$Treatment)[3]] <- NA
   p399.dat$MissTrt[p399.dat$Trial=="Plymouth" & p399.dat$Treatment == levels(p399.dat$Treatment)[10]] <- NA

   p399.dat$MissRep[p399.dat$Trial=="Plymouth" & p399.dat$RepNo == 2] <- NA

   p399.dat$Unrep[p399.dat$Trial=="Clinton" & p399.dat$RepNo == 1] <- NA
   p399.dat$Unrep[p399.dat$Trial=="Clinton" & p399.dat$RepNo == 3] <- NA
   return(p399.dat)
},as.list(c()))
