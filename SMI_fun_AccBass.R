# -------------------------------------------------
# Author: Enzo Basso
# Affiliation: Osa Conservation
# Email: enzobasso@osaconservation.org
# Date: 2026-01-28
# Description: Function for estimating the Scaled Mass Index (SMI) based on Peig & Green (2009)
# https://nsojournals.onlinelibrary.wiley.com/doi/abs/10.1111/j.1600-0706.2009.17643.x
# -------------------------------------------------
# --- Versions used ---
# R version 4.5.0 (2025-04-11)
# smatr 3.4-8

# Note:
# x = Dataset with the morphometric variables
# y = Dataset with body mass

# --- SMI function ---
SMI_fun = function(x, y) {
  #.1 Log–log correlation analysis between body mass and morphometric variables
  #.Note: 'everything' propagates NA; any calculation involving a column with NA will result in NA
  corr = sapply(x, function(var) cor(log(y), log(var), use = 'everything')) 
  
  #.1.1 Selecting the morphometric variable that best correlates with body mass   
  best_var_idx = which.max(abs(corr))
  best_var_name = names(x)[best_var_idx]
  best_var = x[[best_var_idx]]
  
  #.Library loading
  if(!requireNamespace('smatr', quietly = TRUE)) {
    stop("The package 'smatr' is required. Install it first.")
  }
  
  library('smatr')
  
  #.2 SMA model estimation
  SMI.mod = sma(log(y) ~ log(best_var))
  bsma = coef(SMI.mod)[2]
  
  #.3 SMI estimation
  L0 = mean(best_var)
  Mi = y
  L1 = best_var
  #.Formula for the SMI
  SMI = Mi * (L0/L1)^bsma
  
  #.4 Output exploration
  #.Colors
  r_p_c = 'white'
  r_p_b = 'steelblue'
  smi_p_c = 'black'
  l_col = 'black'
  hl_col = 'gray70'
  
  #.Plots
  par(mfrow = c(1, 3), mar = c(4, 4, 4, 4), pty = 'm')
  
  #.Step 1
  plot(best_var, y, main = 'Step 1', 
       xlab = 'L', ylab = 'M', pch = 24, bg = r_p_c, col = r_p_b, cex = 1.2)
  
  #.Step 2
  plot(log(best_var), log(y), main = 'Step 2',
       xlab = 'ln(L)', ylab = 'ln(M)', pch = 24, bg = r_p_c, col = r_p_b, cex = 1.2)
  #.bSMA slope
  labsma = bquote(b[SMA] == .(round(bsma, 2)))
  abline(SMI.mod, col = 'red', lty = 2, lwd = 1.5)
  text(min(log(best_var)), max(log(y)), labels = labsma,
       pos = 4, col = 'red', cex = 0.9)
  
  #.Step 3
  plot(best_var, y, main = 'Step 3', 
       xlab = 'L', ylab = 'M', pch = 24, bg = r_p_c, col = r_p_b, cex = 1.2)
  #.Vertical line L0
  labL0 = bquote(L[0] == .(round(L0, 2)))
  abline(v = L0, col = 'red', lty = 2, lwd = 1.5)
  text(min(best_var), max(y), labels = labL0,
       pos = 4, col = 'red', cex = 0.9)
  #.bSMA slope applied to each individual
  for(i in 1:length(L1)) {
    lines(c(L1[i], L0), c(y[i], SMI[i]), col = l_col, lwd = 1.5)
    #.Segment connecting the scaled value of L0 with the estimated SMI for each individual
    lines(c(min(L1), L0), c(min(SMI[i]), SMI[i]),
          col = hl_col, lty = 1)
    
  }
  
  #.Points marking the intersection of the bSMA line with each individual’s scaled L0
  points(rep(L0, length(SMI)), SMI, pch = 21, col = r_p_c, 
         bg = smi_p_c, cex = 1.2)
  #.Step included only to improve the visual appearance of the plot
  points(best_var, Mi, pch = 24, bg = r_p_c, col = r_p_b, 
         cex = 1.2)
  
  #.4 Output visualization
  Index = data.frame(SMI = round(SMI, 1), BestVar = best_var, Mass = y)
  names(Index)[names(Index) == 'BestVar'] = best_var_name
  return(list(BestVariable = best_var_name, 
              Correlation = corr[best_var_idx],
              SMA_slope = bsma,
              L0 = L0,
              Index = Index,
              AllCorrelations = corr))
  
}

# --- Run the function ---
smi_vul = SMI_fun(x, y)
print(smi_vul)






