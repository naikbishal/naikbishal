function[Ke_i, Be_i, DOF_i, C_i]= Stiffness_quad(element, Elementdata, Mesh, Ncoord, XNI);
  
   %Initialize relevant matrices:
    Ke_i= zeros(8,8);
    Be_i= zeros(3,8);
  
    %Extracting the data for this member.
    Node_j = Elementdata (element, 1);
    Node_k = Elementdata (element, 2);
    Node_l = Elementdata (element, 3);
    Node_m = Elementdata (element, 4);
    
    %Populating DOF_i using Node_i%
    DOF_i(1,1:2)  = [2*Node_j-1 2*Node_j];%First two columns for jth node
    DOF_i(1,3:4)  = [2*Node_k-1 2*Node_k];% Last two columns for kth node
    DOF_i(1,5:6)  = [2*Node_l-1 2*Node_l];%First two columns for lth node
    DOF_i(1,7:8)  = [2*Node_m-1 2*Node_m];% Last two columns for mth node
    
    %Element properties%
    E_i = Mesh(element,3); 
    nu_i = Mesh(element,4);
    thickness_i = Mesh(element, 6);
    
    %Constitutive matrix%
    C_i = (E_i/(1-nu_i*nu_i))*[ 1   nu_i  0
                               nu_i  1    0
                                0    0 (1-nu_i)*0.5 ];
                            
   %Extracting nodal co-ordinates of corresponding nodes of the element%                         
   x1=Ncoord(Node_j,1); 
   x2=Ncoord(Node_k,1); 
   x3=Ncoord(Node_l,1); 
   x4=Ncoord(Node_m,1);
   
   y1=Ncoord(Node_j,2); 
   y2=Ncoord(Node_k,2); 
   y3=Ncoord(Node_l,2); 
   y4=Ncoord(Node_m,2);
  
   %Stiffness matrix calculation%
   for count=1:4
    xi = XNI(count,1) ; eta= XNI(count,2); %Extracting gauss point values%
    N1= (1/4)*((1-xi)*(1-eta));
    N2= (1/4)*((1+xi)*(1-eta)); 
    N3= (1/4)*((1+xi)*(1+eta));
    N4= (1/4)*((1-xi)*(1+eta));
    
    %Jacobian matrix%
    J = 0.25*[ (-(1-eta)*x1+(1-eta)*x2+(1+eta)*x3-(1+eta)*x4) (-(1-eta)*y1+(1-eta)*y2+(1+eta)*y3-(1+eta)*y4)
      (-(1-xi)*x1-(1+xi)*x2+(1+xi)*x3+(1-xi)*x4)   (-(1-xi)*y1-(1+xi)*y2+(1+xi)*y3+(1-xi)*y4) ];
   
   %A matrix%
    A = (1/det(J))*[J(2,2) -J(1,2)  0      0 
                 0       0    -J(2,1)  J(1,1)
                -J(2,1) J(1,1) J(2,2) -J(1,2) ];
    
    %G matrix%      
    G = (1/4)*[ -(1-eta) 0 (1-eta) 0 (1+eta) 0 -(1+eta) 0 
            -(1-xi)  0 -(1+xi) 0 (1+xi)  0  (1-xi)  0 
             0 -(1-eta) 0 (1-eta) 0 (1+eta) 0 -(1+eta) 
             0 -(1-xi)  0 -(1+xi) 0 (1+xi)  0  (1-xi) ];
   
    %B matrix%     
    B = A*G;
    
    %Sum over all the four gauss points to Ke_i%
    Ke_i = Ke_i + B'*C_i*B*det(J)*thickness_i;
    
    %Sum over all the gauss point to get Be_i%
    Be_i = Be_i + B;
   end
end
   
