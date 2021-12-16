function [c_cor]= SOFT_DECODER_GROUPE12_2(c,H,P,MAX_ITER)
    mat=size(H);
    lignes=mat(1); 
    colonnes=mat(2);
    
    
    
    c_cor=c;
    iter= 1;
    
    parity=sum(mod(H*c_cor,2)); % Si la parite est verifiee, parity vaut 0 et l'algorithme s'arrete
    
    Q_1 = zeros(colonnes,1);
    Q_0 = zeros(colonnes,1);
    R = zeros(lignes,colonnes);
    
    q_0=zeros(colonnes,lignes);
    q_1=zeros(colonnes,lignes);
     
    K = ones(lignes,colonnes);
    for i = 1:colonnes  
        for j = 1:lignes
            q_1(i,j) = P(i);
            q_0(i,j) = 1-P(i);
        end
    end
    
  while (iter<=MAX_ITER && parity~=0)
      
      
        fprintf("\nD�cod�: ");
        fprintf("%g", c_cor);
        fprintf("\nParity: ");
        fprintf("%g", mod(H*c_cor,2));
        fprintf("\n");
    
        for j=1:lignes 
            for i=1:colonnes 
                if(H(j,i)==1)
                    prod = 1;
                    %R(j,i) = 1;
                    for i_prime=1:colonnes
                             if(i_prime ~= i)
                                %R(j,i) = R(j,i)*(1-2*q_1(i_prime,j));
                                prod = prod * (1-2*q_1(i_prime,j));
                             end

                    end
                    R(j,i)=(1/2)+(1/2)*R(j,i);
                end
                
            end
        end
 
        for i=1:colonnes  
            for j=1:lignes 
                    if(H(j,i)==1)
                        q_0(i,j) = 1;
                        q_1(i,j) = 1;

                        for j_prime=1:lignes
                             if(j_prime ~= j)
                                q_0(i,j) = q_0(i,j)*R(j_prime,i);
                                q_1(i,j) = q_1(i,j)*(1-R(j_prime,i));
                             end
                        end   
                        q_0(i,j) = q_0(i,j)*(1-P(i));
                        q_1(i,j) = q_1(i,j)*P(i);
                        K(i,j) = 1/(q_0(i,j)+q_1(i,j));
                        %q_1(i,j) = q_1(i,j) / (q_1(i,j) + q_0(i,j)); %normalisation
                        
                    end
                    
            end
        end 
        
        
        for i=1:colonnes  
            Q_0(i) = 1;
            Q_1(i) = 1; 
            for j=1:lignes
                if(H(j,i)==1)
                    Q_0(i) = Q_0(i)*R(j,i);
                    Q_1(i) = Q_1(i)*(1-R(j,i));
                end
            end
            Q_0(i) = Q_0(i)*K(i,1)*(1-P(i));
            Q_1(i) = Q_0(i)*K(i,1)*P(i);
            
            
            fprintf("Pos : %d\n", i);
            fprintf("Q1 : %d\n", Q_1(i));
            fprintf("Q0 : %d\n", Q_0(i));
            
           
            if(Q_0(i)<Q_1(i))
               dec=1; 
            else
               dec=0;
            end
            
            c_cor(i)=dec;
            
        end
        
        fprintf("\nMOD : ");
        fprintf("%g", mod(H*c_cor, 2));
        fprintf("\n");

    parity=sum(mod(H*c_cor,2));
    iter=iter+1;
  end
  return;
end
