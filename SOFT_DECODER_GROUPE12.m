function [c_cor]= SOFT_DECODER_GROUPE12(c,H,P,MAX_ITER)
    mat=size(H);
    lignes=mat(1); 
    colonnes=mat(2);
    
    c_cor=c;
    iter= 1;
    
    parity=sum(mod(H*c_cor,2)); 
    

    R = zeros(lignes,colonnes);
    
    q_0=zeros(colonnes,lignes);
    q_1=zeros(colonnes,lignes);
     
    for i = 1:colonnes  
        for j = 1:lignes
            q_1(i,j) = P(i);
            q_0(i,j) = 1-P(i);
        end
    end
    
    
    
  while (iter<=MAX_ITER && parity~=0)
      
   
        for j=1:lignes 
            for i=1:colonnes 
                if(H(j,i)==1)
                    prod = 1;
                    for i_prime=1:colonnes
                             if(i_prime ~= i)
                                prod = prod *(1-2*q_1(i_prime,j));
                             end

                    end
                    R(j,i)=(1/2)+((1/2)*prod);
                end
                
            end
        end
 
        for i=1:colonnes  
            for j=1:lignes 
                    if(H(j,i)==1)
                        prod_0 = 1; 
                        prod_1 = 1; 
                        for j_prime=1:lignes
                             if(j_prime ~= j)
                                  prod_0 = prod_0 *R(j_prime,i);
                                  prod_1 = prod_1*(1-R(j_prime,i));
                             end
                        end   
                        q_0(i,j) = prod_0*(1-P(i));
                        q_1(i,j) = prod_1*P(i);
                        q_1(i,j) = q_1(i,j) / (q_1(i,j) + q_0(i,j)); %normalisation
                        
                    end
                    
            end
        end 
        
        
        for i=1:colonnes  
            prod_0 = 1; 
            prod_1 = 1;
            for j=1:lignes
                if(H(j,i)==1)
                    prod_0 = prod_0*R(j,i);
                    prod_1 = prod_1*(1-R(j,i));
                end
            end
              Q_0 = prod_0*(1-P(i));
              Q_1 = prod_1*(P(i));
            
           
            if(Q_0<Q_1)
               dec=1; 
            else
               dec=0;
            end
            
            c_cor(i)=dec;
            
        end
        

    parity=sum(mod(H*c_cor,2));
    iter=iter+1;
  end
  return;
end
