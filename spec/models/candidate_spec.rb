require "rails_helper"

describe Candidate do
  context "validation" do
    it "attributes cannot be blank" do
      candidate = Candidate.new(email: "milena@mail.com", password:"123456")

      expect(candidate.valid?).to eq false
      expect(candidate.errors.count).to eq 3
    end

    it "biography is optional" do
      candidate = Candidate.new(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999", 
                                email: "milena@mail.com", password:"123456")

      expect(candidate.valid?).to eq(true)
    end

    it "error messages are in portuguese" do
      candidate = Candidate.new

      candidate.valid?

      expect(candidate.errors[:full_name]).to include("não pode ficar em branco")
      expect(candidate.errors[:cpf]).to include("não pode ficar em branco")
      expect(candidate.errors[:phone]).to include("não pode ficar em branco")
    end

    it "cpf must be uniq" do
      Candidate.create!(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999", 
                        email: "milena@mail.com", password:"123456")
      candidate = Candidate.new(cpf: "11111111")

      candidate.valid?

      expect(candidate.errors[:cpf]).to include("já está em uso")
    end
  end
end
