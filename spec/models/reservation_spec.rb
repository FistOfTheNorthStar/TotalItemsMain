RSpec.describe(Reservation, type: :model) do
  describe 'associations' do
    subject { build(:reservation, item: build(:item)) }

    it { should belong_to(:item) }
    it { should delegate_method(:account).to(:item) }
  end

  describe 'validations' do
    subject { build(:reservation, item: build(:item)) }

    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:status) }

    let!(:item) { create(:item, reservation_limit: 10) }
    it 'validates numericality of quantity' do
      reservation = Reservation.create(quantity: -1, item: item, status: 'pending')
      expect(reservation).to_not(be_valid)
      expect(reservation.errors[:quantity]).to(include('must be greater than or equal to 0'))
    end
  end

  describe 'enums' do
    it { should define_enum_for(:status)
                  .with_values([:pending, :payment_begin, :payment_end, :canceled, :expired, :failed, :completed]) }
  end

  describe 'within_reservation_limit' do
    let(:item) { create(:item, reservation_limit: 5) }
    let(:reservation) { build(:reservation, item: item) }

    context 'when quantity exceeds limit' do
      before { reservation.quantity = 6 }

      it 'is invalid' do
        expect(reservation).not_to(be_valid)
        expect(reservation.errors[:base]).to(include("This item has reached its reservation limit"))
      end
    end

    context 'when quantity is within limit' do
      before { reservation.quantity = 5 }

      it 'is valid' do
        expect(reservation).to(be_valid)
      end
    end

    context 'when item has no reservation limit' do
      before { item.reservation_limit = nil }

      it 'is valid with any quantity' do
        reservation.quantity = 999
        expect(reservation).to(be_valid)
      end
    end
  end

  describe 'scopes' do
    describe '.pending_and_old' do
      let!(:old_pending) { create(:reservation, status: :pending, created_at: 20.minutes.ago) }
      let!(:new_pending) { create(:reservation, status: :pending, created_at: 10.minutes.ago) }
      let!(:old_completed) { create(:reservation, status: :completed, created_at: 20.minutes.ago) }

      it 'returns pending reservations older than 15 minutes' do
        expect(described_class.pending_and_old).to(include(old_pending))
        expect(described_class.pending_and_old).not_to(include(new_pending))
        expect(described_class.pending_and_old).not_to(include(old_completed))
      end
    end
  end

  describe 'callbacks' do
    describe 'after_commit' do
      let(:reservation) { create(:reservation) }
      let(:broadcaster) { instance_double(ReservationStatusBroadcaster) }

      before do
        allow(ReservationStatusBroadcaster).to(receive(:new)
                                                 .with(reservation.id, reservation.status)
                                                 .and_return(broadcaster))
        allow(broadcaster).to(receive(:broadcast))
      end

      context 'when status changes' do
        it 'broadcasts the status change' do
          expect(broadcaster).to(receive(:broadcast))
          reservation.update(status: :payment_begin)
        end
      end

      context 'when status does not change' do
        it 'does not broadcast' do
          expect(broadcaster).not_to(receive(:broadcast))
          reservation.update(quantity: 2)
        end
      end
    end
  end
end