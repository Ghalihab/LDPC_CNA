function [c_cor]= HARD_DECODEUR(c,H,MAX_ITER)
    mat=size(H);
    M=mat(1);
    N=mat(2);
    %Transformation de la matrice H
    H_real=double(H);
    
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
    trans_c=transpose(c_cor);
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
    compt=0;

  while (iter<MAX_ITER && any(parity_check))
      iter=iter+1;
      c_bis=c_cor;
    for c_node=1:N  %On parcourt le vecteur c
       f_node_dec = zeros(1,wc); 
        for i=1:M  %On parcourt la matrice H (lignes puis colonnes)
           res_wc = 0;
            for j=1:N
                if(j ~= c_node && H_real(i,c_node)==1)
                    if (H_real(i,j)==1)
                    
                    res_wc = xor(res_wc, c_bis(j));
                    end
                end
               %On vérifie que ce f node est bien connecté au c node
            
            end    
            if (H_real(i,c_node)==1)
                compt=compt+1;
                f_node_dec(compt)=res_wc; 
                
            end 
        end
        %On prend en compte la valeur de c
            disp('F node est');
                
        f_node_dec(wc+1)=c_bis(c_node);
        disp(f_node_dec);
        maj_0=sum(f_node_dec == 0);
        maj_1=sum(f_node_dec == 1);
        compt=0;
        dec=0;
        if(maj_1>maj_0)
           dec=1; 
        end
            disp(c_cor)

        c_cor(c_node)=dec;
        trans_c=transpose(c_cor);
    end
        parity_check=H_real*trans_c;
    disp(c_cor)
  end
end