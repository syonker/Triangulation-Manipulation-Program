
%Name: 
%    getu
%
%Purpose:
%    This method will be used to apply the Dirichlet boundary condition.
%    Where Vbound indicates we need the displacement to be zero.
%
%Parameters:
%    A - ((2x#vertices) x (2x#vertices)) stiffness matrix
%    F - ((2x#vertices) x 1) vector which represent the force value of each
%         vertex
%    Vbound (#vertices x 3) - matrix which shows which vertices were chosen
%            to be Dirichlet boundary points
%
%Return Values:
%    u - ((2x#vertices) x 1) vector which represents the displacment each 
%         vertex will recieve (our solution)
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [u] = getu(A,F,Vbound)

    s = size(A,1);
    u=zeros(s,1);
    m=1;
    B=zeros(s);
    C=zeros(s,1);

    for j=1:(s/2)
        
        if (Vbound(j,3) == 1)

        else
            n=1;
            for i=1:s

              if (i<=(s/2))

                if (Vbound(i,3) == 1)
                else
                    B(m,n)=A(j,i);
                    n=n+1;
                end

              else

                if (Vbound(i-(s/2),3) == 1)
                else
                    B(m,n)=A(j,i);
                    n=n+1;
                end

              end

            end

            C(m)=F(j);
            m=m+1;
        end
    end


    for j=((s/2)+1):s

        if (Vbound(j-(s/2),3) == 1)
        else
            n=1;
            for i=1:s

              if (i<=(s/2))

                if (Vbound(i,3) == 1)
                else
                    B(m,n)=A(j,i);
                    n=n+1;
                end

              else

                if (Vbound(i-(s/2),3) == 1)
                else
                    B(m,n)=A(j,i);
                    n=n+1;
                end

              end

            end
            C(m)=F(j);
            m=m+1;
        end
    end

    Areduced=zeros(m-1);
    Freduced=zeros(m-1,1);

    for j=1:m-1
        for i=1:m-1
            Areduced(j,i)=B(j,i);
        end
        Freduced(j)=C(j);
    end

    ureduced=Areduced\Freduced;
    m=1;

    for j=1:(s/2)

        if (Vbound(j,3) == 1)
            u(j)=0;
        else
            u(j)=ureduced(m);
            m=m+1;
        end
    end

    for j=((s/2)+1):s

        if (Vbound(j-(s/2),3) == 1)
            u(j)=0;
        else
            u(j)=ureduced(m);
            m=m+1;
        end
    end

 
end

