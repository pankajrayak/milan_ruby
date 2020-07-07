class ClassRoom 
  
    def initialize(students) 
        @students = students 
    end

   def list_student_names
        @students.map(&:name).join(',')
   end

end

describe ClassRoom do
    it 'the list_student_names method should work' do
        stu1=double('student')
        stu2=double('student')

        allow(stu1).to receive(:name) {'john smith'}
        allow(stu2).to receive(:name) {'jill smith'}

        cr = ClassRoom.new [stu1,stu2]
        expect(cr.list_student_names).to eq('john smith,jill smith')
    
    end

end