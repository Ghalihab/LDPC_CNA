function output = SOFT_DECODEUR(c,h,p,MAX_ITER)
    mat=size(H);
    M=mat(1);
    N=mat(2);
    %Transformation de la matrice H
    H_real=double(H);
    c = double(c); 
    
    %on stock les couples de nodes 
    
    pause(1);
    node_it=0; %node iterator
    for i=1:M
       for j=1:N
          if (H(i,j)==true)
              
              H_real(i,j)=1;
          else
              H_real(i,j)=0;
          end
       end
    end
    
    

end



function [r_0,r_1]=majr(q, m,n,H)
r_0=zeros(m,n);
r_1=zeros(m,n);
for j=[1:m]
    r_ji=1;
    for i_prime = [1:n]
        
        for i = [1,n]
            if (H(i,j)==1)
                if (i~=i_prime)
                r_ji= r_ji*(1-2*q(i,j));
                end
                r_ji=r_ji/2+1/2;
            else
                r_ji=0;
            end
        
        end
    end
    r_0(j,i_prime)=r_ji;
    r_1(j,i_prime)=1-r_ji;
    
end
end




function [q_0,q_1]=majq(P,K,r_0,r_1, m,n,H)
q_0=zeros(m,n);
q_1=zeros(m,n);
for i = [1:n]
    q_ji_0=1;
    q_ji_1=1;
    for j_prime = [1,m]
        for j = [1,m]
            if (H(i,j)==1)
                if (j~=j_prime)
                q_ji_0= q_ji_0*r_0(i,j);
                q_ji_1= q_ji_1*r_1(i,j)
                end
            else
                q_ji_0=0;
                q_ji_1=0;
            end
        end
    q_ji_0=q_ji_0*(1-P(i))*K(i,j);
    q_ji_1=q_ji_1*K(i,j)*P(i);
    q_0(i,j_prime)=q_ji_0;
    q_1(i,j_prime)=q_ji_1;
    end
    
end



end

