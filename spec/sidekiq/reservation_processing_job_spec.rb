# require 'rails_helper'
# require 'sidekiq/testing'
#
# RSpec.describe(ReservationProcessingJob, type: :job) do
#   let(:account) { create(:account) }
#   let(:item) { create(:item, account: account, available_items: 10) }
#   let(:reservation) { create(:reservation, item: item, quantity: 2, status: :pending) }
#
#   before do
#     Sidekiq::Testing.inline!
#   end
#
#   after do
#     Sidekiq::Testing.fake!
#   end
#
#   describe '#perform' do
#     subject(:perform_job) { described_class.perform_async(reservation.id) }
#
#     context 'when the reservation exists' do
#       it 'processes the reservation successfully' do
#         expect { perform_job }.to(change { reservation.reload.status }
#                                     .from('pending').to('completed'))
#       end
#
#       it 'sleeps for the correct amount of time emulating payment calls' do
#         expect_any_instance_of(described_class).to(receive(:sleep).twice.with("10"))
#         perform_job
#       end
#     end
#
#     context 'when the reservation is not found' do
#       before do
#         reservation.destroy
#       end
#
#       it 'logs the error and finishes the job' do
#         expect(Rails.logger).to(receive(:error).with(/Could not find reservation/))
#         perform_job
#       end
#     end
#
#     context 'when an unexpected error occurs' do
#       before do
#         allow(Reservation).to(receive(:find).and_raise(StandardError.new("Unexpected error")))
#       end
#
#       it 'raises a ReservationProcessingJobError' do
#         expect { perform_job }.to(raise_error(
#                                     ReservationProcessingJob::ReservationProcessingJobError,
#                                     /Job with reservation_id: #{reservation.id} with Unexpected error/
#                                   ))
#       end
#     end
#   end
#
#   describe '.sidekiq_retries_exhausted' do
#     let!(:job) do
#       {
#         'class' => 'ReservationProcessingJob',
#         'args' => [ reservation.id ],
#         'error_message' => 'Job failed'
#       }
#     end
#
#     it 'logs a warning and sets the ticket available again' do
#       expect(Sidekiq.logger).to(receive(:warn).with("Failed ReservationProcessingJob with [#{reservation.id}]: Job failed"))
#       expect { described_class.sidekiq_retries_exhausted(job) }
#         .to(change { item.reload.available_items }.by(2)
#                                                   .and(change { reservation.reload.status }.to('failed')))
#     end
#   end
#
#   describe '#set_items_available_again' do
#     it 'increments available items and marks the reservation as failed' do
#       expect {
#         described_class.new.send(:set_items_available_again, reservation.id)
#       }.to(change { item.reload.available_items }.by(2)
#                                                  .and(change { reservation.reload.status }.to('failed')))
#     end
#   end
# end
