% Deep Learning Project
%Author: Walter Freire
%Course: EE8608
%based on the paper Scene Recognition by Manifold regularized deep learning architecture

%lets test sift

function Y=SceneRecognition(dataT);
if ~exist('dataT','var')
    load('15Scene_30Tr_15Te_TrainingInput','dataT','training_label');
   
end
data = dataT';

layers = 1;
W = ones(size(data,1));
for L = 1:layers

size(data)



options=make_options;
%options.NN=NN;
options.Kernel='linear';
%options.KernelParam=SIGMA;
%options.gamma_A=gamma_A; 
%options.gamma_I=gamma_I; 
options.GraphWeights='heat';
%options.GraphWeightParam=SIGMA;
%options.LaplacianDegree=DEGREE;
options.PointCloud = data;

M = lle(dataT,5,128);
%already done
%I=eye(size(M')); 
%M = (I-M')*(I-M')';
%what i thought it was
% I=eye(size(M')); 
% M = (I-M')*(I-M')';
options.DeformationMatrix = M;

K=calckernel(options,data);

W = (K./(K.*W +0.1.*W+(0.1/4).*(W.^(1/2)))).*W;
%disp('size of W');
%size(W)
D = eye(size(W)).*((1/2)*(W+W'));
WT = 1/2*(W+W')*(D^(-1));


%Gsym = compute_relation(WT);
Gsym = compute_relation(eye(size(WT,1)) - WT);
%disp('size of G sym');
%size(Gsym)
%G = compute_relation(dataT);
nbCluster = 4;
[NcutDiscrete,NcutEigenvectors,NcutEigenvalues] = ncutW(Gsym,nbCluster);


 Y = NcutEigenvectors'*inv(D^(1/2));
%size(Y)
%figure(L+6)
%plot(NcutEigenvectors)

YT = Y';
data = Y';
end
%%end loop
save('weight15Scene_30Tr_15Te_Data','Y','training_label');
disp(['The computation took ' num2str(toc) ' seconds']);
 % figure(1);
%plot(Y);
return
% display clustering result


% the deformed kernel matrix evaluated over test data
