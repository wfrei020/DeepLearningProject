


function [predict_label, accuracy, dec_values] = modelling();
if(0)
[heart_scale_label, heart_scale_inst] = libsvmread('../lib/matlab/liblinear-2.30/heart_scale');
model = train(heart_scale_label, heart_scale_inst, '-c 1');
size(model)
size(heart_scale_label)
heart_scale_inst(1:10,:)
[predict_label, accuracy, dec_values] = predict(heart_scale_label, heart_scale_inst, model); % test the training data

return
end
load('weightData','Y','training_label');
%load('15SceneCategoryTest','dataT','training_label');

model = train(training_label', sparse(Y'));

img_path = '../../../src/datasets/15CategoryDataSet/completeSet/15-Scene/02/480.jpg';
feature = SIFT_feature(img_path);
dataT = feature;
expected_label=3.*ones(1,size(feature,2));
YH = SceneRecognition(dataT);
%Y(:,1:10)
disp('training labl size');
size(training_label')
disp('Y size');
%size(Y')
disp('model');
size(model)
disp('expected labl size');
size(expected_label')
disp('YH size');
size(YH')
[predict_label, accuracy, dec_values] = predict(expected_label', sparse(YH'), model, '-b 1');
