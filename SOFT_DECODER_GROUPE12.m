function [c_cor]= SOFT_DECODER_GROUPE12(c,H,P_1,MAX_ITER)
    mat=size(H);
    M=mat(1);
    N=mat(2);
    
    
    %Transformation de la matrice H
    H_real=double(H);
    c = double(c);
        %Hsys=mod(rref(H),2);
    %M_gen =gen2par(Hsys);
   % H = [0 1 0 1 1 0 0 1; 1 1 1 0 0 1 0 0; 0 0 1 0 0 1 1 1; 1 0 0 1 1 0 1 0];
   % message = [0 1 1 1];
    %encode = message * M_gen
    %
    %encode_c = mod(encode,2)
    pause(1);
    for i=1:M
       for j=1:N
          if (H(i,j)==true)
              H_real(i,j)=1;
          else
              H_real(i,j)=0;
          end
       end
    end
    %Fin de la transformation
    
    %Il faut gérer les H non systématiques
    
    %On initialise c_cor
    c_cor=c;
    trans_c=c_cor;
    %Calcul du nombre de lien entre les f_node et les c_nodes
    wr=0;
    for i=1:N
       if H_real(1,i)~=0
           wr=wr+1;
       end
    end
    wc=wr*M/N;
    iter= 0;
    
    parity_check=H_real*trans_c;
    P_1
    
  while (iter<MAX_ITER && any(parity_check))
    compt=0;
    P_bis_0=zeros(N,1);
    P_bis_0=P_bis_0+1;
    P_bis_1=zeros(N,1);
    Q_0=zeros(N,1);
    Q_1=zeros(N,1);
    Q_0=Q_0+1;
    Q_1=Q_1+1;
    P_bis_1=P_bis_1+1;
    P_0=1-P_1;
    R_0=P_0;
    K=zeros(N,1);
    iter=iter+1;
    for c_node=1:N  %On parcourt le vecteur c
       f_node_dec = zeros(1,wc); 
        for i=1:M  %On parcourt la matrice H (lignes)
           res_wc = 0;
            for j=1:N %On parcourt la matrice H (colonnes)
                %Si l'indice du vect est égale à 1 sur la matrice 
                %Et la colonne parcouru n'est pas égale à l'indice colonne
                %(parity check on other node)
                if(j ~= c_node && H_real(i,c_node)==1) 
                      %Si la matrice est égale à 1 chaque indice
                    if (H_real(i,j)==1)
                    R_0(i)=R_0(i)*(1-2*P_1(i));
                    end
                end
               %On vérifie que ce f node est bien connecté au c node
            
            end    
             R_0(i)=(1/2)*R_0(i)+(1/2);
             
         
           
        end
        
        %On prend en compte la valeur de c
        %disp('F node est');
        for i=1:M
            for j=1:N 
                if (j ~= c_node && H_real(i,c_node)==1)
                    P_bis_0(i)=P_bis_0(i)*R_0(i);
                    P_bis_1(i)=P_bis_1(i)*(1-R_0(i));
                end
            end
            P_bis_1(i)=P_bis_1(i)*P_1(i);
            P_bis_0(i)=P_bis_0(i)*(1-P_1(i));
            K(i)=1/(P_bis_1(i)+P_bis_0(i));
        end
        for i=1:M
            if (H_real(i,c_node)==1)
                for j=1:N 
                
                    Q_0(i)=Q_0(i)*R_0(i);
                    Q_1(i)=Q_1(i)*(1-R_0(i));
                end
            end
            
            Q_0(i)=Q_0(i)*K(i)*(1-P_1(i));
            Q_1(i)=Q_1(i)*K(i)*P_1(i);

        end
        
        if(Q_0(c_node)<Q_1(c_node))
           dec=1; 
        else
           dec=0;
        end
           % disp(c_cor);
        Q_0
        Q_1
        c_cor(c_node)=dec;
        c_cor
        trans_c=c_cor;
    end
        R_0=1;
        parity_check=H_real*trans_c;
        P_1=P_bis_1;
        
    %disp(c_cor);
  end
end
